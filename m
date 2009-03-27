Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpi2.ngi.it ([88.149.128.21]:59811 "EHLO smtpi2.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZC0KSY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 06:18:24 -0400
Received: from [127.0.0.1] (81-174-56-138.static.ngi.it [81.174.56.138])
	by smtpi2.ngi.it (8.13.8/8.13.8) with ESMTP id n2R9EZc9010757
	for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 10:14:36 +0100
Message-ID: <49CC98FA.1030106@robertoragusa.it>
Date: Fri, 27 Mar 2009 10:14:34 +0100
From: Roberto Ragusa <mail@robertoragusa.it>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
References: <49B9BC93.8060906@nav6.org>	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>	 <20090319101601.2eba0397@pedra.chehab.org>	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>	 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com> <a3ef07920903200807l501889bfu87d7906a082127e7@mail.gmail.com>
In-Reply-To: <a3ef07920903200807l501889bfu87d7906a082127e7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VDR User wrote:
> On Thu, Mar 19, 2009 at 11:55 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> * At the peak, you will get the maximum quality
>> * falling down the slope to the left and right you will get falling
>> signal strengths
>> * Still rolling down, you will get increasing ERROR's, with still
>> UNCORRECTABLES being steady.
>> * Still falling down at the thresholds where you are about to loose
>> frontend LOCK, you will see UNCORRECTABLE's getting incremented.
>>
>> Couple this logic into a program, with a feedback to the ROTOR and
>> you get an automated satellite positioner, with a good fine tuned
>> position.
>
> This would make for a very very useful tool to have.  I can't count
> the number of times I've seen people inquire about tools to help them
> aim their dish and this sounds like the perfect solution to that long
> standing problem.  Especially if it returned the network id once it's
> achieve a lock so the user can see if he's pointed to the correct
> satellite.

If you have a motor and you are able to automatically peak satellites,
the only thing missing is a program to find all the signals automatically,
including the ones which are turned on and off in a matter of minutes.

Just google for *blindscan* (and maybe my name) to find a
utility I wrote years ago and abandoned after failing to get
the corresponding mt312-autosymbolrate kernel patch integrated.

Next step, automatically upload found signals on some site, maybe
including a frame from the received video stream and let users
comment/moderate interesting ones on a sort of forum. :-)
Hmmmm, feeds...

Best regards.
-- 
   Roberto Ragusa    mail at robertoragusa.it

