Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:24117 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaIRMVi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 08:21:38 -0400
Message-ID: <541ACE4E.1040308@cisco.com>
Date: Thu, 18 Sep 2014 14:21:34 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH v2] [media] BZ#84401: Revert "[media] v4l: vb2: Don't
 return POLLERR during transient buffer underruns"
References: <1410826255-2025-1-git-send-email-m.chehab@samsung.com>	<20140918070619.32d4e4b1@recife.lan>	<541AAFA6.6080605@cisco.com>	<20140918075005.11bd495f@recife.lan>	<541ACAF9.4030204@cisco.com> <20140918091516.42dc6bb3@recife.lan>
In-Reply-To: <20140918091516.42dc6bb3@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/18/14 14:15, Mauro Carvalho Chehab wrote:
> Em Thu, 18 Sep 2014 14:07:21 +0200
> Hans Verkuil <hansverk@cisco.com> escreveu:
> 
>> My patch is the *only* fix for that since that's the one that addresses
>> the real issue.
>>
>> One option is to merge my fix for 3.18 with a CC to stable for 3.16.
>>
>> That way it will be in the tree for longer.
>>
>> Again, the revert that you did won't solve the regression at all. Please
>> revert the revert.
> 
> Well, some patch that went between 3.15 and 3.16 broke VBI. If it was
> not this patch, what's the patch that broke it?

The conversion of saa7134 to vb2 in 3.16 broke the VBI support in saa7134.

It turns out that vb2 NEVER did this right.

Remember that saa7134 was only the second driver with VBI support (after
em28xx) that was converted to vb2, and that this issue only happens with
teletext applications that do not call STREAMON before calling poll().

They rely on the fact that poll returns POLLERR to call STREAMON. Ugly
as hell, and not normal behavior for applications.

So that explains why it was never found before.

Note that em28xx (converted to vb2 quite some time before) fails as well.
So this regression has been there since 3.9 (when em28xx was converted).
I tested my fix with em28xx as well and that will worked fine.

Regards,

	Hans
