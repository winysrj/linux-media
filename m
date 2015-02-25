Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51050 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbbBYTpI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 14:45:08 -0500
MIME-Version: 1.0
In-Reply-To: <20150225182308.GB27977@hudson.localdomain>
References: <AE3729EDFAD6D548827A31E3191F1E5B0138E8D7@EAPEX1MAIL1.st.com> <20150225182308.GB27977@hudson.localdomain>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Wed, 25 Feb 2015 20:44:52 +0100
Message-ID: <CAL8zT=gfvQ=yUKswfPA9MDxLohR32J+45S5zSx+-CsS4DG+8fA@mail.gmail.com>
Subject: Re: 0001-media-vb2-Fill-vb2_buffer-with-bytesused-from-user.patch
To: Jeremiah Mahler <jmmahler@gmail.com>,
	Sudip JAIN <sudip.jain@st.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sudip,

2015-02-25 19:23 GMT+01:00 Jeremiah Mahler <jmmahler@gmail.com>:
> Sudip,
>
> On Wed, Feb 25, 2015 at 03:29:22PM +0800, Sudip JAIN wrote:
>> Dear Maintainer,
>>
>> PFA attached patch that prevents user from being returned garbage bytesused value from vb2 framework.
>>
>> Regards,
>> Sudip Jain
>>
>
> Patches should never be submitted as attachments, they should be inline.
>
> See Documentation/SubmittingPatches for more info.

You also can have a look here :
http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

In fact, is the patch on top of master tree ? According to line
numbers, I would say no.

Thx,
JM
