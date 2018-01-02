Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752054AbeABNwj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 08:52:39 -0500
Date: Tue, 2 Jan 2018 08:52:38 -0500 (EST)
From: Bob Peterson <rpeterso@redhat.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: dri-devel@lists.freedesktop.org, dev@openvswitch.org,
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
Message-ID: <1878806802.2632123.1514901158666.JavaMail.zimbra@redhat.com>
In-Reply-To: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1514386305-7402-1-git-send-email-Julia.Lawall@lip6.fr>
Subject: Re: [Cluster-devel] [PATCH 00/12] drop unneeded newline
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Original Message -----
| Drop newline at the end of a message string when the printing function adds
| a newline.

Hi Julia,

NACK.

As much as it's a pain when searching the source code for output strings,
this patch set goes against the accepted Linux coding style document. See:

https://www.kernel.org/doc/html/v4.10/process/coding-style.html#breaking-long-lines-and-strings

Regards,

Bob Peterson
