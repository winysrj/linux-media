Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:61755 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2JVLRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 07:17:43 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCA00HVWKPZ4R00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Oct 2012 12:17:59 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MCA00CD0KPGXE40@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Oct 2012 12:17:41 +0100 (BST)
Message-id: <50852B54.1040002@samsung.com>
Date: Mon, 22 Oct 2012 13:17:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Alain VOLMAT <alain.volmat@st.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [media-workshop] Tentative Agenda for the November workshop
References: <201210221035.56897.hverkuil@xs4all.nl>
 <10009130.xLxCsb7QR7@avalon> <5085258E.6090803@samsung.com>
 <E27519AE45311C49887BE8C438E68FAA01012DA81D4A@SAFEX1MAIL1.st.com>
In-reply-to: <E27519AE45311C49887BE8C438E68FAA01012DA81D4A@SAFEX1MAIL1.st.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/22/2012 12:57 PM, Alain VOLMAT wrote:
> Hi all,
> 
> Could someone summaries very rapidly what is this create/select context stuff ? 
> For now I do not plan to be in Barcelona more than 1 day but at the same time
> don't want to miss something that might be useful for us.

Please see this thread for more details:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg52168.html

This is about creating, selecting device configuration contexts and
handling e.g. camera modes like viewfinder and still capture.
Currently only mem-to-mem devices in V4L2 API are allowed to support
multiple device contexts, and those are per file handle.

I hope this clarifies it a bit for you.

--
Regards,
Sylwester



