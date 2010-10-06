Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:57780 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab0JFLsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 07:48:16 -0400
Date: Wed, 6 Oct 2010 13:48:55 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca, audio and ov534: regression.
Message-ID: <20101006134855.43879d74@tele>
In-Reply-To: <20101006123321.baade0a4.ospite@studenti.unina.it>
References: <20101006123321.baade0a4.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 6 Oct 2010 12:33:21 +0200
Antonio Ospite <ospite@studenti.unina.it> wrote:

> with 2.6.36-rc6 I can't use the ov534 gspca subdriver (with PS3 eye)
> anymore, when I try to capture video in dmesg I get:
> gspca: no transfer endpoint found
> 
> If I revert commit 35680ba I can make video capture work again but I
> still don't get the audio device in pulseaudio, it shows up in
> alsamixer but if I try to select it, on the console I get:
> cannot load mixer controls: Invalid argument
> 
> I'll test with latest Jean-François tree, and if it still fails I'll
> try to find a solution, but I wanted to report it quickly first, I
> hope we fix this before 2.6.36.

Hi Antonio,

I think I see why the commit prevents the webcam to work: as it is
done, the choice of the alternate setting does not work with bulk
transfer. A simple fix could be to also check bulk transfer when
skipping an alt setting in the function get_ep().

About audio stream, I do not see how it can have been broken.

Might you send me the full USB information of your webcam?

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
