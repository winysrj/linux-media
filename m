Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51072 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbaKTQQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 11:16:00 -0500
Date: Thu, 20 Nov 2014 14:15:54 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: v4l-utils stable release 1.6.1
Message-ID: <20141120141554.4a2e36e8@recife.lan>
In-Reply-To: <546E093D.4030203@googlemail.com>
References: <546E093D.4030203@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 20 Nov 2014 16:31:09 +0100
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> do you consider something from these commits as important enough for a 
> bugfix release?

>From my side, those are bug fixes that affect two RC6 tables:
       ir-keytable: fix a regression introduced by fe2aa5f767eba
       rc: Update the protocol name at RC6 tables

Applying just the first is enough. Basically, RC6 tables are described
as RC6_MCE. The first patch makes the ir-keytable to accept both syntaxes;
the second one fixes the two existing RC6_MCE tables.

This one is an important bug fixes for DVB-S/S2 frequency storage:
       libdvbv5: properly represent Satellite frequencies

This is not properly a bug fix, but I would also add it, as it fixes the
documentation:
	README: better document the package

This is a bug fix, but it affects only the keymap sync from Kernel,
so probably not worth backporting, except if you also intend to run
make sync-with-kernel at the fix tree:
       gen_keytables.pl: Fix a regression at RC map file generation

In such case, I also suggest to backport those patches:
       rc_maps.cfg: reorder entries alphabetically
       rc: sync with Kernel
       rc: copy userspace-only maps to a separate dir

This one also seems to be a backport fix:
       rc_keymaps: allwinner: S/KEY_HOME/KEY_HOMEPAGE/

That's all from remote controllers and libdvbv5 API side.

Regards,
Mauro
