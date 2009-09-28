Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:37768 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZI1RTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 13:19:45 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id F3F67940146
	for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 19:19:44 +0200 (CEST)
Received: from gandalf.hd.free.fr (wmh38-1-82-225-140-65.fbx.proxad.net [82.225.140.65])
	by smtp1-g21.free.fr (Postfix) with ESMTP id E93AE940238
	for <linux-media@vger.kernel.org>; Mon, 28 Sep 2009 19:19:41 +0200 (CEST)
Received: from localhost
	([127.0.0.1] helo=gandalf.localnet ident=domi)
	by gandalf.hd.free.fr with esmtp (Exim 4.69)
	(envelope-from <domi.dumont@free.fr>)
	id 1MsJsx-0004Lt-JW
	for linux-media@vger.kernel.org; Mon, 28 Sep 2009 19:19:40 +0200
From: Dominique Dumont <domi.dumont@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 28 Sep 2009 19:19:38 +0200
References: <cd98718e0909280200r23942bf5r726931bf23fc2bb3@mail.gmail.com> <cd98718e0909280202v5679ffabwaf9c1f6c1bf67734@mail.gmail.com>
In-Reply-To: <cd98718e0909280202v5679ffabwaf9c1f6c1bf67734@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909281919.38386.domi.dumont@free.fr>
Subject: Re: Hauppauge Nova-T 500 regression in dib0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le lundi 28 septembre 2009 11:02:59, vous avez écrit :
> I was wondering if any progress has been made with this issue? I have
> what appears to be the same problem.
> Can you offer any advice on getting this tuner card working with ubuntu
>  Jaunty? Obviously I guess the choices are compile an old kernel, or remove
>  said update from v4l, but I ask anyway just incase there is a better
>  option, or something happening in the near future I could just wait on.

You may have a problem similar to my Nova-T usb box (you card is also using 
USB).

Here's the behavior I see since 2.6.28 (or so): all modules required for nova-
T are loaded, and device files created BEFORE the usb box is ready. Sometimes, 
the red LED on the box lights up after 20s, sometimes after 60s.

Needless to say, if vdr starts before the LED goes on, the Nova-T device is 
not seen by vdr.

I have no real solution. The only work-around I've found is to delay vdr start 
with a 'sleep 60' in its startup script.

Hope this helps
