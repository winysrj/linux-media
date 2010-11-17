Return-path: <mchehab@pedra>
Received: from mx1.polytechnique.org ([129.104.30.34]:47128 "EHLO
	mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032Ab0KQVws (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 16:52:48 -0500
Received: from [192.168.0.1] (mic92-4-82-224-132-174.fbx.proxad.net [82.224.132.174])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ssl.polytechnique.org (Postfix) with ESMTPSA id B3AED14000633
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 22:52:46 +0100 (CET)
Message-ID: <4CE44EAF.9000705@free.fr>
Date: Wed, 17 Nov 2010 22:52:47 +0100
From: Massis Sirapian <msirapian@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: HVR900H : analog audio input
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

In parallel of my IR investigations, I've tried to capture audio+video 
through RCA+S-VIDEO.

tvtime works perfectly to show the video stream, but it complains about 
a mute card for audio.

Loading tm6000-alsa doesn't change anything and alsamixer says device 
has no control.

dmesg says
[ 8289.655732] tm6000_alsa: module is from the staging directory, the 
quality is unknown, you have been warned.
[ 8289.657114] tm6000 #0/1: Registered audio driver for TM5600/60x0 
Audio at bus 2 device 5
[ 8289.657116] tm6000 #0: Initialized (TM6000 Audio Extension) extension
[ 8289.680811] tm6000 #0/1: Stopping audio DMA
[ 8289.714352] tm6000 #0/1: Stopping audio DMA
[ 8289.750136] tm6000 #0/1: Stopping audio DMA
[ 8289.786166] tm6000 #0/1: Stopping audio DMA
[ 8289.822196] tm6000 #0/1: Stopping audio DMA
[ 8289.857689] tm6000 #0/1: Stopping audio DMA
[ 8289.897843] tm6000 #0/1: Starting audio DMA
[ 8294.973206] tm6000 #0/1: Stopping audio DMA
[ 8295.008157] tm6000 #0/1: Stopping audio DMA
[ 8295.044065] tm6000 #0/1: Stopping audio DMA

I also have a lot of :
[ 8433.752545] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)

Is it normal (analog audio not implemented) ?

Another symptom is also that modprobing tm6000 takes like 1 minute to 
load, and opening TV (DVB or analog) takes 20-30 sec the first time 
(switching channels is faster then). Is it an expected behaviour (looks 
like it takes time after having loaded the firmware) ?

Thanks

Massis
