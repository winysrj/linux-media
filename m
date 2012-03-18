Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34087 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2CROtK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Mar 2012 10:49:10 -0400
Received: by lbbgm6 with SMTP id gm6so2815035lbb.19
        for <linux-media@vger.kernel.org>; Sun, 18 Mar 2012 07:49:08 -0700 (PDT)
Message-ID: <4F65F5E2.2030302@gmail.com>
Date: Sun, 18 Mar 2012 15:49:06 +0100
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Terratec H7(az6007), CI support and Kaffeine
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

This mail is a small request to see if anyone else except me that has 
problem with viewing encrypted channels.

My problem is as follows:
When viewing encrypted channels I can watch without problem.
When I change to another encrypted channel inside kaffeine nothing 
happens. The EPG tells me which program it is but no video is displayed.

To be able to watch the channel I have to close down kaffeine and 
restart it. Then works every time.

I can change to an unencrypted channel without problem but not switch 
back to an encrypted one.

This is using DVB-C and kaffeine 1.2.2 as supplied in Ubuntu 11.10. I am 
using kernel 3.0.0-16-generic with media_build installed for access to 
az6007-driver.

I am using the CI-patch from Jose Alberto Reguero since I'm not sure it 
has been added to media_build yet.

Is this a Kaffeine-problem or is it a driver/dvb-problem?
