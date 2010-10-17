Return-path: <mchehab@pedra>
Received: from v-smtp-auth-relay-2.gradwell.net ([79.135.125.41]:35886 "EHLO
	v-smtp-auth-relay-2.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932340Ab0JQKrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 06:47:21 -0400
Received: from zntrx-gw.adsl.newnet.co.uk ([80.175.181.245] helo=echelon.upsilon.org.uk country=GB ident=dave&pop3&upsilon$org&uk)
          by v-smtp-auth-relay-2.gradwell.net with esmtpa (Gradwell gwh-smtpd 1.290) id 4cbad436.4e0f.28
          for linux-media@vger.kernel.org; Sun, 17 Oct 2010 11:47:18 +0100
          (envelope-sender <news004@upsilon.org.uk>)
Message-ID: <0wdXDqCnQtuMFwvF@echelon.upsilon.org.uk>
Date: Sun, 17 Oct 2010 11:47:03 +0100
To: linux-media@vger.kernel.org
From: dave cunningham <news004@upsilon.org.uk>
Subject: AF9013/15 I2C problems
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii;format=flowed
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A few months ago I switched systems and started having problems with a 
pair of WT-220U sticks 
<http://www.spinics.net/lists/linux-media/msg22309.html>.

I got nowhere with this problem so gave up changing to a pair of AT9015 
sticks.

I started with a Tevion DK-5203 using firmware 4.65.

I have no problems in this configuration.

I then added a KWorld 399U. On insertion I got a kernel message saying 
firmware 4.95 is required so I switched to this.

Now neither stick works correctly (either individually or with the other 
stick).

At boot things are fine and I can use either stick (and both tuners on 
the 399U).

At some point however I get a flood of message in the syslog like this:

Oct 16 18:43:18 beta dhcpd: DHCPACK on 192.168.0.9 to 00:1c:c0:8c:88:7d via eth0
Oct 16 19:47:10 beta kernel: [ 8510.288055] af9013: I2C write failed reg:ae00 len:1
Oct 16 19:47:14 beta kernel: [ 8514.312050] af9013: I2C read failed reg:d330
Oct 16 19:47:18 beta kernel: [ 8518.336048] af9013: I2C read failed reg:9bee
Oct 16 19:47:22 beta kernel: [ 8522.360053] af9013: I2C read failed reg:d330
Oct 16 19:47:26 beta kernel: [ 8526.384054] af9013: I2C read failed reg:d330
Oct 16 19:47:31 beta kernel: [ 8530.408060] af9013: I2C read failed reg:d330
Oct 16 19:47:35 beta kernel: [ 8534.432060] af9013: I2C read failed reg:9bee
Oct 16 19:47:39 beta kernel: [ 8538.456051] af9013: I2C read failed reg:d330
Oct 16 19:47:43 beta kernel: [ 8542.480055] af9013: I2C read failed reg:d330
Oct 16 19:47:47 beta kernel: [ 8546.504050] af9013: I2C read failed reg:d330
Oct 16 19:47:51 beta kernel: [ 8550.528048] af9013: I2C read failed reg:9bee
Oct 16 19:47:55 beta kernel: [ 8554.552056] af9013: I2C read failed reg:d330
Oct 16 19:47:59 beta kernel: [ 8558.576062] af9013: I2C read failed reg:d330
Oct 16 19:48:03 beta kernel: [ 8562.600056] af9013: I2C read failed reg:d330
Oct 16 19:48:07 beta kernel: [ 8566.624074] af9013: I2C read failed reg:9bee
Oct 16 19:48:11 beta kernel: [ 8570.648052] af9013: I2C read failed reg:d330
Oct 16 19:48:15 beta kernel: [ 8574.672053] af9013: I2C read failed reg:d330
Oct 16 19:48:19 beta kernel: [ 8578.696059] af9013: I2C read failed reg:d330
Oct 16 19:48:23 beta kernel: [ 8582.720039] af9013: I2C read failed reg:9bee
Oct 16 19:48:27 beta kernel: [ 8586.744056] af9013: I2C read failed reg:d330
Oct 16 19:48:31 beta kernel: [ 8590.768039] af9013: I2C read failed reg:d330
Oct 16 19:48:35 beta kernel: [ 8594.792053] af9013: I2C read failed reg:d330
Oct 16 19:48:39 beta kernel: [ 8598.816066] af9013: I2C read failed reg:9bee
Oct 16 19:48:43 beta kernel: [ 8602.840054] af9013: I2C read failed reg:9bee
Oct 16 19:48:47 beta kernel: [ 8606.864133] af9013: I2C read failed reg:d330
Oct 16 19:48:51 beta kernel: [ 8610.888106] af9013: I2C write failed reg:ae00 len:1
Oct 16 19:48:55 beta kernel: [ 8614.912052] af9013: I2C read failed reg:9bee
Oct 16 19:48:59 beta kernel: [ 8618.936056] af9013: I2C read failed reg:9bee

The host machine has now slowed to a crawl and I have to remove the 
stick(s) and reboot to recover.

I'm currently on hg version <14319:37581bb7e6f1>, on a debian-squeeze 
system, kernel 2.6.32.

I've googled and found various people seeing similar problems but have 
yet to come across a solution.

Would anyone have any suggestions (note if I switch back to firmware 
4.65 with just the Tevion stick things are fine - I'd like to use the 
KWorld stick if possible though)?

Thanks,
-- 
Dave Cunningham                                  dave at upsilon org uk
                                                  PGP KEY ID: 0xA78636DC
