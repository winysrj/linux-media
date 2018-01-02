Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:37224 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751332AbeABPQh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 10:16:37 -0500
Date: Tue, 2 Jan 2018 16:16:30 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Bart Van Assche <Bart.VanAssche@wdc.com>
cc: "rpeterso@redhat.com" <rpeterso@redhat.com>,
        "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "esc.storagedev@microsemi.com" <esc.storagedev@microsemi.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "alexander.shishkin@linux.intel.com"
        <alexander.shishkin@linux.intel.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [Cluster-devel] [PATCH 00/12] drop unneeded newline
In-Reply-To: <1514905900.4242.4.camel@wdc.com>
Message-ID: <alpine.DEB.2.20.1801021615510.23552@hadrien>
References: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr>         <1878806802.2632123.1514901158666.JavaMail.zimbra@redhat.com>         <1019862289.2632779.1514901387442.JavaMail.zimbra@redhat.com>         <alpine.DEB.2.20.1801021458360.24055@hadrien>
 <1514905900.4242.4.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 2 Jan 2018, Bart Van Assche wrote:

> On Tue, 2018-01-02 at 15:00 +0100, Julia Lawall wrote:
> > On Tue, 2 Jan 2018, Bob Peterson wrote:
> > > ----- Original Message -----
> > > > ----- Original Message -----
> > > >
> > > Still, the GFS2 and DLM code has a plethora of broken-up printk messages,
> > > and I don't like the thought of re-combining them all.
> >
> > Actually, the point of the patch was to remove the unnecessary \n at the
> > end of the string, because log_print will add another one.  If you prefer
> > to keep the string broken up, I can resend the patch in that form, but
> > without the unnecessary \n.
>
> Please combine any user-visible strings into a single line for which the
> unneeded newline is dropped since these strings are modified anyway by
> your patch.

That is what the submitted patch (2/12 specifically) did.

julia
