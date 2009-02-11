Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbZBKARl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 19:17:41 -0500
Date: Tue, 10 Feb 2009 22:17:10 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Eduard Huguet <eduardhc@gmail.com>, linux-media@vger.kernel.org
Subject: Re: cx8802.ko module not being built with current HG tree
Message-ID: <20090210221710.389c264e@pedra.chehab.org>
In-Reply-To: <200902102221.40067.hverkuil@xs4all.nl>
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com>
	<200902102132.00114.hverkuil@xs4all.nl>
	<20090210184147.61d4655e@pedra.chehab.org>
	<200902102221.40067.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 10 Feb 2009 22:21:39 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:


> > $ grep CONFIG_HAS_DMA /usr/src/kernels/2.6.18-125.el5-x86_64/.config
> > CONFIG_HAS_DMA=y
> 
> Oops, this fixes a different bug. It is still a bug fix, though, since it 
> prevents CX88 from being build at all on any vanilla kernels < 2.6.22. Can 
> you apply it?

Applied, thanks.

> > Also, the original reporter were for an Ubuntu kernel 2.6.22.
> 
> I did some more testing and the bug disappears in kernel 2.6.25. Also, if I 
> just run 'make', then the .config file it produces is fine. I wonder if it 
> isn't a bug in menuconfig itself.

It seems to be a bug at the Kbuild, fixed on Feb, 2008, on this changeset: 
commit 587c90616a5b44e6ccfac38e64d4fecee51d588c (attached).

As explained, after the patch description, the value for the Kconfig var, after
the patch, uses this formula:

    	(value && dependency) || select

where value is the default value.

Since CONFIG_CX88_MPEG is defined as:

config VIDEO_CX88_MPEG
        tristate
        depends on VIDEO_CX88_DVB || VIDEO_CX88_BLACKBIRD
        default y

And there there's no select, the value of CONFIG_CX88_MPEG is determined by:
	('y' && dependency)

The most complex case is when we have CX88 defined as:
	CX88 = 'y'

if both CX88_DVB and CX88_BLACKBIRD are defined as 'm' (or one of them is 'n'
and the other is 'm'), then CX88_MPEG is defined as:
	CX88_MPEG = 'm'

If one of CX88_DVB or CX88_BLACKBIRD is defined as 'y'; then we have:
	CX88_MPEG = 'y'

If both are 'n', we have:
	CX88_MPEG = 'n'

So, it seems that, after commit 587c90616a5b44e6ccfac38e64d4fecee51d588c,
everything is working as expected. We just need to provide a hack at the
out-of-tree build system for kernels that don't have this commit applied.

Cheers,
Mauro

commit 587c90616a5b44e6ccfac38e64d4fecee51d588c
Author: Roman Zippel <zippel@linux-m68k.org>
Date:   Mon Feb 11 21:13:47 2008 +0100

    kconfig: fix select in combination with default
    
    > The attached .config (with current -git) results in a compile
    > error since it contains:
    >
    > CONFIG_X86=y
    > # CONFIG_EMBEDDED is not set
    > CONFIG_SERIO=m
    > CONFIG_SERIO_I8042=y
    >
    > Looking at drivers/input/serio/Kconfig I simply don't get how this
    > can happen.
    
    You've hit the rather subtle rules of select vs default. What happened is
    that SERIO is selected to m, but SERIO_I8042 isn't selected so the default
    of y is used instead.
    We already had the problem in the past that select and default don't work
    well together, so this patch cleans this up and makes the rule hopefully
    more straightforward. Basically now the value is calculated like this:
    
    	(value && dependency) || select
    
    where the value is the user choice (if available and the symbol is
    visible) or default.
    
    In this case it means SERIO and SERIO_I8042 are both set to y due to their
    default and if SERIO didn't had the default, then the SERIO_I8042 value
    would be limited to m due to the dependency.
    
    I tested this patch with more 10000 random configs and above case is the
    only the difference that showed up, so I hope there is nothing that
    depended on the old more complex and subtle rules.
    
    Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
    Tested-by: Adrian Bunk <bunk@kernel.org>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 3929e5b..4a03191 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -298,22 +298,30 @@ void sym_calc_value(struct symbol *sym)
 		if (sym_is_choice_value(sym) && sym->visible == yes) {
 			prop = sym_get_choice_prop(sym);
 			newval.tri = (prop_get_symbol(prop)->curr.val == sym) ? yes : no;
-		} else if (EXPR_OR(sym->visible, sym->rev_dep.tri) != no) {
-			sym->flags |= SYMBOL_WRITE;
-			if (sym_has_value(sym))
-				newval.tri = sym->def[S_DEF_USER].tri;
-			else if (!sym_is_choice(sym)) {
-				prop = sym_get_default_prop(sym);
-				if (prop)
-					newval.tri = expr_calc_value(prop->expr);
+		} else {
+			if (sym->visible != no) {
+				/* if the symbol is visible use the user value
+				 * if available, otherwise try the default value
+				 */
+				sym->flags |= SYMBOL_WRITE;
+				if (sym_has_value(sym)) {
+					newval.tri = EXPR_AND(sym->def[S_DEF_USER].tri,
+							      sym->visible);
+					goto calc_newval;
+				}
 			}
-			newval.tri = EXPR_OR(EXPR_AND(newval.tri, sym->visible), sym->rev_dep.tri);
-		} else if (!sym_is_choice(sym)) {
-			prop = sym_get_default_prop(sym);
-			if (prop) {
+			if (sym->rev_dep.tri != no)
 				sym->flags |= SYMBOL_WRITE;
-				newval.tri = expr_calc_value(prop->expr);
+			if (!sym_is_choice(sym)) {
+				prop = sym_get_default_prop(sym);
+				if (prop) {
+					sym->flags |= SYMBOL_WRITE;
+					newval.tri = EXPR_AND(expr_calc_value(prop->expr),
+							      prop->visible.tri);
+				}
 			}
+		calc_newval:
+			newval.tri = EXPR_OR(newval.tri, sym->rev_dep.tri);
 		}
 		if (newval.tri == mod && sym_get_type(sym) == S_BOOLEAN)
 			newval.tri = yes;
