Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:17705 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031994AbbKFHvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Nov 2015 02:51:49 -0500
Subject: Re: [PATCH 0/2] [media] c8sectpfe: Deletion of a few unnecessary
 checks
To: SF Markus Elfring <elfring@users.sourceforge.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <kernel@stlinux.com>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <563BA3CC.4040709@users.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
	<kernel-janitors@vger.kernel.org>,
	Julia Lawall <julia.lawall@lip6.fr>
From: Maxime Coquelin <maxime.coquelin@st.com>
Message-ID: <563C5BCD.806@st.com>
Date: Fri, 6 Nov 2015 08:50:37 +0100
MIME-Version: 1.0
In-Reply-To: <563BA3CC.4040709@users.sourceforge.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

On 11/05/2015 07:45 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 5 Nov 2015 19:39:32 +0100
>
> Another update suggestion was taken into account after a patch was applied
> from static source code analysis.
>
> Markus Elfring (2):
>    Delete unnecessary checks before two function calls
>    Combine three checks into a single if block
>
>   drivers/media/platform/sti/c8sectpfe/c8sectpfe-common.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
>
For the series:
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks!
Maxime
