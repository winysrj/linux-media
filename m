Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:43166 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922Ab3EWJgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 05:36:45 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] [media] vpif_display: fix error return code in vpif_probe()
Date: Thu, 23 May 2013 11:26:53 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>, mchehab@redhat.com,
	yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Wei Yongjun <weiyj.lk@gmail.com>
References: <CAPgLHd_iDfVzq2S_uSh1tBVpQdFa4oyMpWGovDDNCYsh0bLJog@mail.gmail.com> <CA+V-a8v5Msfwr11tpC5xR90e5E02Mz+OJcqnYohmp2ri_VgC1Q@mail.gmail.com> <CA+V-a8vTXaDmPuPxFUDxv4+pQc4jbwBafUWu7Y-Hdbbdo+=Xqg@mail.gmail.com>
In-Reply-To: <CA+V-a8vTXaDmPuPxFUDxv4+pQc4jbwBafUWu7Y-Hdbbdo+=Xqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231126.53333.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 23 May 2013 11:25:25 Prabhakar Lad wrote:
> Hi Hans,
> 
> On Mon, May 13, 2013 at 11:34 AM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
> > Hi Wei,
> >
> > Thanks for the patch.
> >
> > On Mon, May 13, 2013 at 11:27 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> >> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >>
> >> Fix to return -ENODEV in the subdevice register error handling
> >> case instead of 0, as done elsewhere in this function.
> >>
> >> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >
> Can you pick this patch ? and a similar looking patch for vpif display.

It's already in my queue.

	Hans
