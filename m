Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-db02.mx.aol.com ([205.188.91.96]:61801 "EHLO
	imr-db02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab2DATKt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 15:10:49 -0400
Message-ID: <4F78A815.9050102@netscape.net>
Date: Sun, 01 Apr 2012 16:10:13 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Steven Toth <stoth@kernellabs.com>
Subject: Re: Broken driver cx23885 mygica x8507
References: <4F77B099.7030109@netscape.net>
In-Reply-To: <4F77B099.7030109@netscape.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

I found that this is the patch that makes no sound:

http://git.kernellabs.com/?p=stoth/cx23885-hvr1850-fixups.git;a=commit;h=e187d0d51bcd0659eeac1d608284644ec8404239

I will try to find that lines are responsible.

Thanks,

Alfredo


El 31/03/12 22:34, Alfredo Jesús Delaiti escribió:
> Hi
>
> Some of the changes between 3.2 and 3.3 kernel have left without 
> sound, the card Mygica X8507.
> With kernel 3.0, 3.1 and 3.2 this worked fine.
> I tested with OpenSuSE, with two kernel that provides by distribution 
> and Kubunto with the kernel download from http://www.kernel.org/. In 
> both cases the same problem occurs.

-- 
Dona tu voz
http://www.voxforge.org/es

