Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:4642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab1EABSp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 21:18:45 -0400
Message-ID: <4DBCB4EF.5070104@redhat.com>
Date: Sat, 30 Apr 2011 22:18:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?windows-1252?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
CC: linux-media@vger.kernel.org
Subject: Re: Help to make a driver. ISDB-Tb
References: <4DBC422F.10102@netscape.net>
In-Reply-To: <4DBC422F.10102@netscape.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Alfredo,

Em 30-04-2011 14:09, Alfredo Jesús Delaiti escreveu:
> Hi
> 
> I'm trying to make the driver for X8507 Mygica.
> I have reference to the Mygica X8506 card, because I found that only differ in the "frontend" according to photos I've seen on the Internet.
> 
> I am following the recommended process:
> 
> http://www.linuxtv.org/wiki/index.php/Development:_How_to_add_support_for_a_device

> drivers/media/video/cx23885/cx23885-cards.c:240:3: error: ‘CX23885_BOARD_MYGICA_X8507’ undeclared here (not in a function)

You forgot to declare this constant somewhere with #define.

> Clarification: I am not a programmer and am trying to get to work compared with other controller. I am using the kernel 2.6.38 and OpenSUSE 11.4
> I attached the modified file

It is not that simple. You need to setup the GPIO pins of your device, and
set the DVB frontend according to how this is wired inside the board,
and providing the information about the used frontend. I think that your
device is based on mb86a20s demod. You need to tell that to cx23885-dvb,
providing the type of connection used (serial or parallel).

It requires you some knowledge about Engineering, as well as C programming
experience.

Mauro.
