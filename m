Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34520 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1B0MmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 07:42:21 -0500
Received: by bwz15 with SMTP id 15so3039481bwz.19
        for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 04:42:19 -0800 (PST)
Subject: Re: Genuis Emessenger 310 webcam slow work with pac7302 in
 2.6.37.1 kernel
From: housegregory299 <housegregory299@gmail.com>
To: linux-media@vger.kernel.org
In-Reply-To: <1298810271.4400.43.camel@debian>
References: <1298718695.2178.30.camel@debian> <4D693EB3.6080302@freemail.hu>
	 <1298762810.2022.54.camel@debian>  <4D6A018E.7090404@freemail.hu>
	 <1298810271.4400.43.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Feb 2011 18:42:03 +0600
Message-ID: <1298810523.4788.2.camel@debian>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В Вск, 27/02/2011 в 18:37 +0600, housegregory299 пишет:
> > As I understand the webcam was not working properly even using 2.6.32
> > kernel.
> 
> Yes, this is so. But in near installed Windows 7 webcam also work slow
> and picture quality is worse  than on Debian with 2.6.37. I think my
> webcam very limited functionality. I have to keep both the kernels on my
> system - 2.6.32 and 2.6.37 and switch between them on the need.  
> 
> > Are you using v4l2ucp for setting exposure value? This command is
> > available
> > from the v4l2ucp Debian package. Are the other controls working
> > properly?
> 
> I use v4l2ucp from command line to saving and loading webcam's
> customised parameters, (v4l2ucp -s .webcam and v4l2ucp -l .webcam)
> but with other keys are not used. All parameters in Guvcview work fine
> and properly, except Exposure. 
> 
> > Some more hints for the trying the "test images": make sure that
> > v4l-utils
> > Debian package is installed ("apt-get install v4l-utils" as root).
> > Then
> > you can use the command "v4l2-dbg --set-register=0x72 x" where "x" is
> > any
> > number between 0 and 15. This command has to be executed as root. To
> > return
> > to the normal operation just use the zero value for x. I'm not sure
> > that
> > these test patterns will work for your webcam model also, but it would
> > be
> > interesting to try.
> 
> command "v4l2-dbg --set-register=0x72 10 not help to me: With value 0
> output are similar:
> 
> root@debian:/home/t800# v4l2-dbg --set-register=0x72 10
> Failed to set register 0x00000072 value 0xa: Invalid argument
> 
> But i try setup my webcam with v4l-utils.
> 
> > The main problem is that the manufacturer of the chip which is
> > included
> > in your webcam neither released programming documentation nor
> > implemented
> > a standard protocol like USB Video Class. Without documentation open
> > source
> > projects can only use trial and error
> > ( http://en.wikipedia.org/wiki/Trial_and_error ).
> 
> I understand, OK. So.. Which webcam is better suited for Linux systems -
> UVC standard ? This is open? or closed? Sorry, if this question is wrong
> - i don't know which webcam select for my Linux-system.
> 
> > I would strongly recommend to add the mailing list
> > "linux-media@vger.kernel.org"
> > in CC field, so more people can see this conversation. 
> 
> OK. I do it 


