Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay02.digicable.hu ([92.249.128.188]:50780 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab0CaGbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 02:31:36 -0400
Message-ID: <4BB2EC46.1000601@freemail.hu>
Date: Wed, 31 Mar 2010 08:31:34 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Krivchikov Sergei <sergei.krivchikov@gmail.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: genius islim 310 webcam test
References: <68c794d61003301249u138e643am20bb264375c3dfe1@mail.gmail.com>	<4BB2E42B.4090302@freemail.hu> <20100331080757.40f9c478@tele>
In-Reply-To: <20100331080757.40f9c478@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine írta:
> On Wed, 31 Mar 2010 07:56:59 +0200
> Németh Márton <nm127@freemail.hu> wrote:
> 
>> The next thing is that you need to learn how to compile the Linux
>> kernel from source code. There is a description for Ubuntu at
>> https://help.ubuntu.com/community/Kernel/Compile . After you are able
>> to compile and install your new kernel, you can try to apply the
>> patch in this email, recompile the kernel, install the kernel and the
>> modules, unload the gspca_pac7302 kernel module ("rmmod
>> gspca_pac7302"), and then plug the webcam in order it can load the
>> new kernel module. When you were successful with these steps you'll
>> see new messages in the output of "dmesg" command. Please send this
>> output also.
> 
> Hello Németh and Sergei,
> 
> I think the patch is not needed because it just gives the vend:prod
> which is already known by lsusb.

To avoid misunderstandings, the patch I sent is not just printing the
USB vendor ID and product ID but also really enables the pac7302 gspca
subdriver to actually work with the newly added USB IDs.

> On the other hand, compiling a full kernel is not needed with a small
> tarball distribution as the one I have in my page (actual gspca-2.9.10).

This is also a possible way to go, the important thing is that a kernel
module has to be built and the previous version of gspca_pac7302 kernel
module has to be replaced with the newly built one.

Regards,

	Márton Németh

