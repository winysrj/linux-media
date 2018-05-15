Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([50.116.127.2]:38614 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752084AbeEODzg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 23:55:36 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 0BBD7400CA222
        for <linux-media@vger.kernel.org>; Mon, 14 May 2018 22:31:52 -0500 (CDT)
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1524499368.git.gustavo@embeddedor.com>
 <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
 <20180423152455.363d285c@vento.lan>
 <3ab9c4c9-0656-a08e-740e-394e2e509ae9@embeddedor.com>
 <20180423161742.66f939ba@vento.lan>
 <99e158c0-1273-2500-da9e-b5ab31cba889@embeddedor.com>
 <20180426204241.03a42996@vento.lan>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <df8010f1-6051-7ff4-5f0e-4a436e900ec5@embeddedor.com>
Date: Mon, 14 May 2018 22:31:37 -0500
MIME-Version: 1.0
In-Reply-To: <20180426204241.03a42996@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 04/26/2018 06:42 PM, Mauro Carvalho Chehab wrote:

>>
>> I noticed you changed the status of this series from rejected to new.
> 
> Yes.
> 
>> Also, there are other similar issues in media/pci/
> 
> Well, the issues will be there everywhere on all media drivers.
> 
> I marked your patches because I need to study it carefully, after
> Peter's explanations. My plan is to do it next week. Still not
> sure if the approach you took is the best one or not.
> 
> As I said, one possibility is to change the way v4l2-core handles
> VIDIOC_ENUM_foo ioctls, but that would be make harder to -stable
> backports.
> 
> I need a weekend to sleep on it.
> 

I'm curious about how you finally resolved to handle these issues.

I noticed Smatch is no longer reporting them.

Thanks
--
Gustavo
