Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39908 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab2DFAay (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Apr 2012 20:30:54 -0400
Message-ID: <4F7E393B.4040409@iki.fi>
Date: Fri, 06 Apr 2012 03:30:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: pierigno <pierigno@gmail.com>
CC: gennarone@gmail.com, linux-media@vger.kernel.org, m@bues.ch,
	hfvogt@gmx.net, mchehab@redhat.com
Subject: Re: [PATCH] af9035: add several new USB IDs
References: <1333540034-14002-1-git-send-email-gennarone@gmail.com> <4F7C3787.5020602@iki.fi> <4F7C4141.40004@gmail.com> <4F7C481A.2020203@iki.fi> <4F7C4C58.5050703@gmail.com> <CAN7fRVvX2gEWHAEAqqZ1Jbgx+atU8S_dXVc9Q83_o+-L69nq7g@mail.gmail.com> <CAN7fRVsGqUvmNkYbzmf5dKYjc_+n9T_3TTBp7Bawon3-awjfPQ@mail.gmail.com> <4F7DC65F.7030007@gmail.com> <CAN7fRVug2k1VEDEYOaAAg7ecG1jB4bHFWFd2=nsXdvSJuK7AKw@mail.gmail.com>
In-Reply-To: <CAN7fRVug2k1VEDEYOaAAg7ecG1jB4bHFWFd2=nsXdvSJuK7AKw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05.04.2012 22:03, pierigno wrote:
> Damn!! here it is again, corrected. I'm really sorry, thanks for the patience :)
>
>> Also, I think the name should be something like "AVerMedia Twinstar
>> (A825)" since Avermedia code names usually are "Axxx".
>
> I thought the name between parenthesis was after the usb pvid value so
> I used that value.
> This is what I get with lsusb:
>
> # lsusb
> bus 003 Device 002: ID 07ca:0825 AVerMedia Technologies, Inc.
>
> I've modified the name with "AVermedia Twinstar (A825) as you
> suggested, should I revert it?

I applied it!

http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental

It didn't apply for git since errors, but as it was small patch I 
applied it manually.

regards
Antti
-- 
http://palosaari.fi/
