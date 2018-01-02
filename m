Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:62063 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752239AbeABNzd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 08:55:33 -0500
Date: Tue, 2 Jan 2018 14:55:08 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Bob Peterson <rpeterso@redhat.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        dri-devel@lists.freedesktop.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        dccp@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        cluster-devel@redhat.com,
        esc storagedev <esc.storagedev@microsemi.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-ext4@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [Cluster-devel] [PATCH 00/12] drop unneeded newline
In-Reply-To: <1878806802.2632123.1514901158666.JavaMail.zimbra@redhat.com>
Message-ID: <alpine.DEB.2.20.1801021454090.24055@hadrien>
References: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr> <1878806802.2632123.1514901158666.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 2 Jan 2018, Bob Peterson wrote:

> ----- Original Message -----
> | Drop newline at the end of a message string when the printing function adds
> | a newline.
>
> Hi Julia,
>
> NACK.
>
> As much as it's a pain when searching the source code for output strings,
> this patch set goes against the accepted Linux coding style document. See:
>
> https://www.kernel.org/doc/html/v4.10/process/coding-style.html#breaking-long-lines-and-strings

I don't think that's the case:

"However, never break user-visible strings such as printk messages,
because that breaks the ability to grep for them."

julia

>
> Regards,
>
> Bob Peterson
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
