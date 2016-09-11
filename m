Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:43746 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750912AbcIKSF0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 14:05:26 -0400
Message-ID: <1473616576.19464.10.camel@perches.com>
Subject: Re: [PATCH 00/26] constify local structures
From: Joe Perches <joe@perches.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        linux-renesas-soc@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-pm@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-media@vger.kernel.org, linux-can@vger.kernel.org,
        Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Chien Tin Tung <chien.tin.tung@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        tpmdd-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-acpi@vger.kernel.org
Date: Sun, 11 Sep 2016 10:56:16 -0700
In-Reply-To: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2016-09-11 at 15:05 +0200, Julia Lawall wrote:
> Constify local structures.

Thanks Julia.

A few suggestions & questions:

Perhaps the script should go into scripts/coccinelle/
so that future cases could be caught by the robot
and commit message referenced by the patch instances.

Can you please compile the files modified using the
appropriate defconfig/allyesconfig and show the
movement from data to const by using
	$ size <object>.new/old
and include that in the changelogs (maybe next time)?

Is it possible for a rule to trace the instances where
an address of a struct or struct member is taken by
locally defined and declared function call where the
callee does not modify any dereferenced object?

ie:

struct foo {
	int bar;
	char *baz;
};

struct foo qux[] = {
	{ 1, "description 1" },
	{ 2, "dewcription 2" },
	[ n, "etc" ]...,
};

void message(struct foo *msg)
{
	printk("%d %s\n", msg->bar, msg->baz);
}

where some code uses

	message(qux[index]);

So could a coccinelle script change:

struct foo qux[] = { to const struct foo quz[] = {

and

void message(struct foo *msg) to void message(const struct foo *msg)

