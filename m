Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:44470 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752376AbdI2PAu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 11:00:50 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2 09/13] scripts: kernel-doc: parse next structs/unions
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20170929103234.38ea8086@recife.lan>
Date: Fri, 29 Sep 2017 17:00:36 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Transfer-Encoding: 8BIT
Message-Id: <6071B3F0-A0D8-4E03-927D-79C624E3ACAF@darmarit.de>
References: <cover.1506546492.git.mchehab@s-opensource.com>
 <cover.1506546492.git.mchehab@s-opensource.com>
 <b2528c4f1d2e76b7dacde8c5660e94de32e2eb71.1506546492.git.mchehab@s-opensource.com>
 <68968C67-7CD6-4264-A46D-1EE195CBC58D@darmarit.de>
 <20170929090853.469ea73b@recife.lan>
 <768B7EAA-53EB-4D43-95C3-D4710E6DCB41@darmarit.de>
 <20170929103234.38ea8086@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Am 29.09.2017 um 15:33 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>> Sorry if I was unclear. I mean we should not use tabs in reST or in py.
> 
> Ah, OK.
> 
>> In python the indentation is a part of the language syntax, same in
>> reST; the indentation is the markup. It's not only me who recommend to
>> avoid tabs:
>> 
>> - reST: http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#whitespace
> 
> What's said there is that tabs can be used, if tab stops at 8th column:
> 
> 	"Spaces are recommended for indentation, but tabs may also be used. 
> 	 Tabs will be converted to spaces. Tab stops are at every 8th column."
> 
> Basically, it should be doing exactly the same thing as the patch I just
> for kernel-doc script :-)

There is no need to replace tabs in the *prototype* but you are right; in the
kernel-doc comments it is needed. See below where I make a suggestion 
*how to achieve*.

>> - python: https://www.python.org/dev/peps/pep-0008/#tabs-or-spaces
>> 
>> both can handle tabs well (with the cost of confusing when I look at a diff), but
>> in python 3 it gets worse ...
>>  """Python 3 disallows mixing the use of tabs and spaces for indentation."""
> 
> None to argue here. If it is part of the language, either comply or use
> some other language that it isn't position oriented.

Just for info; when Guido van Rossum created python he thought, that
readability counts. With indentation as a part of the syntax, python
forces the developer to write readable code.

> Btw, Python reminds me about Fortran... I remember I lost some compilation
> jobs at the University's mainframe (that used to take an entire day to be
> processed, due to student's jobs being processed only at late night) because,
> on a couple of punched cards there was a missing space, causing the line to
> be considered part of the previous statement...
> 
> Perhaps that's the reason why I'm not a big fan of using tabs/spaces
> to split statements: it reminds me the old days of Fortran 77 on punched
> cards.

I have stack of punched card right here: Nowadays they are excellent
cigarettes filter ;)

> 
>> If we are looking at C sources, there are no such problems since the
>> indentation is not a part of the syntax, so what the Kernel coding style
>> recommends is also correct.
>> 
>>  """Outside of comments, documentation and except in Kconfig, spaces are
>>     never used for indentation"""
>> 
>> Anyway, as long as it works with tabs I can't stop you ;)
>> 
>>> 
>>> Thankfully, solving this issue is a one line perl patch, as explained at:
>>> 	http://perldoc.perl.org/perlfaq4.html#How-do-I-expand-tabs-in-a-string?
>>> 
>>> Something like the enclosed (untested) patch.  
>> 
>> Hm, as far as I see, this will make no sense, since the kernel-doc
>> parser flats prototypes to a one-liner and the reST output is independent
>> (e.g. output_struct_rst) from the origin source code.
> 
> 
> I tested with the following test tag (a modified version of the one you
> pointed:
> 
> 
> <code>
> /**
> * struct voltagedomain - omap voltage domain global structure.
> * @name: Name of the voltage domain which can be used as a unique identifier.
> * @scalable: Whether or not this voltage domain is scalable
> * @node: list_head linking all voltage domains
> * @vc: pointer to VC channel associated with this voltagedomain
> * @vp: pointer to VP associated with this voltagedomain
> * @read: read a VC/VP register
> * @write: write a VC/VP register
> * @read: read-modify-write a VC/VP register
> * @sys_clk: system clock name/frequency, used for various timing calculations
> * @sys_clk.rate: lorem ipsum
> * @sys_clk.foo.boo: foo boo. can't explain @sys_clk.foo.boo.
> * @scale: function used to scale the voltage of the voltagedomain
> * @nominal_volt: current nominal voltage for this voltage domain
> * @volt_data: voltage table having the distinct voltages supported
> *             by the domain and other associated per voltage data.
> * 	       cont with spaces _+ tabs
> */
> struct voltagedomain {
> 	char *name;
> 	bool scalable;
> 	struct list_head node;
> 	struct omap_vc_channel *vc;
> 	const struct omap_vfsm_instance *vfsm;
> 	struct omap_vp_instance *vp;
> 	struct omap_voltdm_pmic *pmic;
> 	struct omap_vp_param *vp_param;
> 	struct omap_vc_param *vc_param;
> 
> 	/* VC/VP register access functions: SoC specific */
> 	u32 (*read) (u8 offset);
> 	void (*write) (u32 val, u8 offset);
> 	u32 (*rmw)(u32 mask, u32 bits, u8 offset);
> 
> 	union {
> 		const char *name;
> 		u32 rate;
> 		union {
> 			int boo;
> 		} foo;
> 	} sys_clk;
> 
> 	int (*scale) (struct voltagedomain *voltdm,
> 		      unsigned long target_volt);
> 
> 	u32 nominal_volt;
> 	struct omap_volt_data *volt_data;
> };
> </code>
> 
> By purpose, the last line of @volt_data contains:
> 	<space><tab><spaces>cont line
> 
> That's obviously something that people should avoid doing, as an
> space before a tab like that is really ugly. 
> 
> Before this patch, kernel-doc script produces:
> 
> 	``volt_data``
> 	  voltage table having the distinct voltages supported
> 	  by the domain and other associated per voltage data.
> 	  	       cont with spaces _+ tabs
> 
> 
> With this patch, it is now outputs fine:
> 
> 
> 	``volt_data``
> 	  voltage table having the distinct voltages supported
> 	  by the domain and other associated per voltage data.
> 	  cont with spaces _+ tabs
> 
> So, I guess we should apply it anyway, as I found several bugs 
> already due to tabs usage on some kernel-doc markups.

I do expand tabs in the feed method of the parser

  https://github.com/return42/linuxdoc/blob/master/linuxdoc/kernel_doc.py#L1713

I guess we should do the same in sub process_file($) with <IN>. My
perl is to bad, may you could take a look at? / Thanks!


 -- Markus --
