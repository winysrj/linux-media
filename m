Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16964 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab2JBIY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 04:24:29 -0400
Received: from eusync3.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MB9009ZTBDKIY50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 09:24:56 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MB900H7IBCQ8K70@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 09:24:27 +0100 (BST)
Message-id: <506AA4B9.7030303@samsung.com>
Date: Tue, 02 Oct 2012 10:24:25 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: arun.kk@samsung.com
Cc: Jeongtae Park <jtp.park@samsung.com>,
	'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Jang-Hyuck Kim <janghyuck.kim@samsung.com>,
	peter Oh <jaeryul.oh@samsung.com>,
	NAVEEN KRISHNA CHATRADHI <ch.naveen@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"kmpark@infradead.org" <kmpark@infradead.org>,
	SUNIL JOSHI <joshi@samsung.com>
Subject: Re: [PATCH v7 5/6] [media] s5p-mfc: MFCv6 register definitions
References: <33463275.230081349157793594.JavaMail.weblogic@epml10>
In-reply-to: <33463275.230081349157793594.JavaMail.weblogic@epml10>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 10/02/2012 08:03 AM, Arun Kumar K wrote:
> Hi Jeongtae Park,
> 
> I have verified the calculation.
> The ALIGN macro is giving a wrong result and I used the macro DIV_ROUND_UP
> in the v8 patchset which is giving the proper result.

Sorry about this misleading suggestion. It should have been DIV_ROUND_UP 
indeed. Your v9 series in general looks good to me, I'd like to send a pull 
request with Kamil's Ack today. 

Well done, thanks!

Regards,
Sylwester
