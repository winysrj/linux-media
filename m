Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:5064 "EHLO
        mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753007AbeABOAx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 09:00:53 -0500
Date: Tue, 2 Jan 2018 15:00:46 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Bob Peterson <rpeterso@redhat.com>
cc: dev@openvswitch.org, linux-s390@vger.kernel.org,
        linux-media@vger.kernel.org, linux-scsi@vger.kernel.org,
        dccp@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        cluster-devel@redhat.com, amd-gfx@lists.freedesktop.org,
        Namhyung Kim <namhyung@kernel.org>, linux-ext4@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        esc storagedev <esc.storagedev@microsemi.com>
Subject: Re: [Cluster-devel] [PATCH 00/12] drop unneeded newline
In-Reply-To: <1019862289.2632779.1514901387442.JavaMail.zimbra@redhat.com>
Message-ID: <alpine.DEB.2.20.1801021458360.24055@hadrien>
References: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr> <1878806802.2632123.1514901158666.JavaMail.zimbra@redhat.com> <1019862289.2632779.1514901387442.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 2 Jan 2018, Bob Peterson wrote:

> ----- Original Message -----
> | ----- Original Message -----
> | | Drop newline at the end of a message string when the printing function adds
> | | a newline.
> |
> | Hi Julia,
> |
> | NACK.
> |
> | As much as it's a pain when searching the source code for output strings,
> | this patch set goes against the accepted Linux coding style document. See:
> |
> | https://www.kernel.org/doc/html/v4.10/process/coding-style.html#breaking-long-lines-and-strings
> |
> | Regards,
> |
> | Bob Peterson
> |
> |
> Hm. I guess I stand corrected. The document reads:
>
> "However, never break user-visible strings such as printk messages, because that breaks the ability to grep for them."
>
> Still, the GFS2 and DLM code has a plethora of broken-up printk messages,
> and I don't like the thought of re-combining them all.

Actually, the point of the patch was to remove the unnecessary \n at the
end of the string, because log_print will add another one.  If you prefer
to keep the string broken up, I can resend the patch in that form, but
without the unnecessary \n.

julia
