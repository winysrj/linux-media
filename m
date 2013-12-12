Return-path: <linux-media-owner@vger.kernel.org>
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:32330
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497Ab3LLPrr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 10:47:47 -0500
Received: from mail131-co9 (localhost [127.0.0.1])	by
 mail131-co9-R.bigfish.com (Postfix) with ESMTP id AF209803D4	for
 <linux-media@vger.kernel.org>; Thu, 12 Dec 2013 15:47:46 +0000 (UTC)
Received: from CO9EHSMHS002.bigfish.com (unknown [10.236.132.239])	by
 mail131-co9.bigfish.com (Postfix) with ESMTP id 52E88640041	for
 <linux-media@vger.kernel.org>; Thu, 12 Dec 2013 15:47:44 +0000 (UTC)
Received: from ct11msg01.am.mot-solutions.com (ct11vts02.am.mot.com
 [10.177.16.160])	by ct11msg01.am.mot-solutions.com (8.14.3/8.14.3) with ESMTP
 id rBCFlgLf011113	for <linux-media@vger.kernel.org>; Thu, 12 Dec 2013
 09:47:42 -0600 (CST)
Received: from db9outboundpool.messaging.microsoft.com
 (mail-db9lp0252.outbound.messaging.microsoft.com [213.199.154.252])	by
 ct11msg01.am.mot-solutions.com (8.14.3/8.14.3) with ESMTP id rBCFlfkC011104
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)	for
 <linux-media@vger.kernel.org>; Thu, 12 Dec 2013 09:47:41 -0600 (CST)
Received: from mail188-db9 (localhost [127.0.0.1])	by
 mail188-db9-R.bigfish.com (Postfix) with ESMTP id B4C196E0AE0	for
 <linux-media@vger.kernel.org.FOPE.CONNECTOR.OVERRIDE>; Thu, 12 Dec 2013
 15:47:40 +0000 (UTC)
From: Brown Patrick-PMH786 <Patrick.Brown@motorolasolutions.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "hdegoede@redhat.com" <hdegoede@redhat.com>
Subject: FW: problems with larger raw video images
Date: Thu, 12 Dec 2013 15:47:34 +0000
Message-ID: <408bcd09c3b54433ad42b45cd4b9c39a@BLUPR04MB737.namprd04.prod.outlook.com>
References: <394dd1cc23004327ab4a171287cee016@BLUPR04MB737.namprd04.prod.outlook.com>,<52A976EF.5010904@cisco.com>
In-Reply-To: <52A976EF.5010904@cisco.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Hans,
 My name is pat brown. I work for motorola solutions.
 I am using a 8 megapixel camera and the lib4vl2 library is giving me an error:

 libv4l2: error converting / decoding frame data: v4l-convert: error destination buffer too small (16777216 < 23970816)
 VIDIOC_DQBUF: Bad address

 v4l-utils-HEAD-4dea4af/lib/libv4l2/libv4l2-priv.h

 I have tracked it down to the following:
 /lib/libv4l2/libv4l2-priv.h:#define V4L2_FRAME_BUF_SIZE (4096 * 4096)

 When I changed the value to :
 /lib/libv4l2/libv4l2-priv.h:#define V4L2_FRAME_BUF_SIZE (2 * 4096 * 4096)

 How can this change be properly integrated. This problem impacts the opencv software package.
 Pat,
 631 880 1188
________________________________________
From: Hans Verkuil <hansverk@cisco.com>
Sent: Thursday, December 12, 2013 1:42 AM
To: Brown Patrick-PMH786
Cc: Seiter Paul-VNJW48; Clayton Mark-AMC036; Super Boaz-SUPER1
Subject: Re: problems with larger raw video images

Hi Pat!

The best approach is to post it to the linux-media mailinglist
(linux-media@vger.kernel.org, no need to subscribe but make sure your
email is normal ascii and not HTML since those are rejected AFAIK)
and Cc Hans de Goede (hdegoede@redhat.com) since he maintains
that code.

Regards,

        Hans

On 12/11/13 21:29, Brown Patrick-PMH786 wrote:
> Hans,
> My name is pat brown. I work for motorola solutions.
> I am using a 8 megapixel camera and the lib4vl2 library is giving me an error:
>
> libv4l2: error converting / decoding frame data: v4l-convert: error destination buffer too small (16777216 < 23970816)
> VIDIOC_DQBUF: Bad address
>
> v4l-utils-HEAD-4dea4af/lib/libv4l2/libv4l2-priv.h
>
> I have tracked it down to the following:
> /lib/libv4l2/libv4l2-priv.h:#define V4L2_FRAME_BUF_SIZE (4096 * 4096)
>
> When I changed the value to :
> /lib/libv4l2/libv4l2-priv.h:#define V4L2_FRAME_BUF_SIZE (2 * 4096 * 4096)
>
> How can this change be properly integrated. This problem impacts the opencv software package.
> Pat,
> 631 880 1188





