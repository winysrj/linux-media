Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52024 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab0BSORx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 09:17:53 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1NiTfu-0007bg-Pe
	for linux-media@vger.kernel.org; Fri, 19 Feb 2010 15:17:51 +0100
Received: from 92.103.125.220 ([92.103.125.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 19 Feb 2010 15:17:41 +0100
Received: from ticapix by 92.103.125.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 19 Feb 2010 15:17:41 +0100
To: linux-media@vger.kernel.org
From: "pierre.gronlier" <ticapix@gmail.com>
Subject: [libdvben50221] new cams, new errors
Date: Fri, 19 Feb 2010 15:17:29 +0100
Message-ID: <hlm6hb$5pm$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I have a irdeto card and three cam modules for it. I'm using a netup
card with the last revision of v4l-dvb driver and the last revision of
dvb-apps.


Using dvb-apps tools, I'm running the same descrambling test with the
three cams but only one cam worked properly.
With dvblast, the three cams work fine.


$ cat mtv-networks.conf #for MTV on Astra 19.2e
MTV:11739:v:0:27500:3021:3022:28652
$

To test them, I run `szap -a 0 -c mtv-networks.conf -rn 1' in a first
terminal and `./test-app 0 312' in a second one. `test-app' is comming
form the test folder of the dvb-apps package.

Here are the outputs of `./test-app 0 312' for the three cams.

*The first one* a cryptoworks cam
$ ./test-app 0 312
Found a CAM on adapter0... waiting...
slotid: 0
tcid: 1
Press a key to enter menu
00:Host originated transport connection 1 connected
00:Public resource lookup callback 1 1 1
00:CAM connecting to resource 00010041, session_number 1
00:CAM successfully connected to resource 00010041, session_number 1
00:test_rm_reply_callback
00:test_rm_enq_callback
00:Public resource lookup callback 2 1 1
00:CAM connecting to resource 00020041, session_number 2
00:CAM successfully connected to resource 00020041, session_number 2
00:test_ai_callback
  Application type: 01
  Application manufacturer: 0000
  Manufacturer code: 033d
  Menu string: TSD Crypt CW
00:Public resource lookup callback 3 1 1
00:CAM connecting to resource 00030041, session_number 3
00:CAM successfully connected to resource 00030041, session_number 3
00:test_ca_info_callback
  Supported CA ID: 0d00


and with a `cat /dev/dvb/adapter0/dvr0 | mplayer -', I checked that the
stream were correctly descrambled.

* The second one* a PowerCam PCam v4.3
$ ./test-app 0 312
Found a CAM on adapter0... waiting...
slotid: 0
tcid: 1
Press a key to enter menu
00:Host originated transport connection 1 connected
00:Public resource lookup callback 1 1 1
00:CAM connecting to resource 00010041, session_number 1
00:CAM successfully connected to resource 00010041, session_number 1
00:test_rm_reply_callback
00:test_rm_enq_callback
00:Public resource lookup callback 2 1 1
00:CAM connecting to resource 00020041, session_number 2
00:CAM successfully connected to resource 00020041, session_number 2
00:test_ai_callback
  Application type: 01
  Application manufacturer: 02ca
  Manufacturer code: 3000
  Menu string: PCAM V4.3
00:Public resource lookup callback 3 1 1
00:CAM connecting to resource 00030041, session_number 3
00:CAM successfully connected to resource 00030041, session_number 3
00:test_ca_info_callback
  Supported CA ID: 4aa1
  Supported CA ID: 0100
  Supported CA ID: 0500
  Supported CA ID: 0600
  Supported CA ID: 0601
  Supported CA ID: 0602
  Supported CA ID: 0603
  Supported CA ID: 0604
  Supported CA ID: 0606
  Supported CA ID: 0608
  Supported CA ID: 0614
  Supported CA ID: 0620
  Supported CA ID: 0622
  Supported CA ID: 0624
  Supported CA ID: 0626
  Supported CA ID: 0628
  Supported CA ID: 0668
  Supported CA ID: 0619
  Supported CA ID: 1702
  Supported CA ID: 1722
  Supported CA ID: 1762
  Supported CA ID: 0b00
  Supported CA ID: 0b01
  Supported CA ID: 0b02
  Supported CA ID: 0d00
  Supported CA ID: 4aa0
00:Connection to resource 00030041, session_number 3 closed
Failed to send CA PMT object
$

And sometimes I got this:
$ ./test-app 0 312
Found a CAM on adapter0... waiting...
slotid: 0
tcid: 1
Press a key to enter menu
00:Host originated transport connection 1 connected
00:Public resource lookup callback 1 1 1
00:CAM connecting to resource 00010041, session_number 1
00:CAM successfully connected to resource 00010041, session_number 1
00:test_rm_reply_callback
00:test_rm_enq_callback
00:Public resource lookup callback 2 1 1
00:CAM connecting to resource 00020041, session_number 2
00:CAM successfully connected to resource 00020041, session_number 2
00:test_ai_callback
  Application type: 01
  Application manufacturer: 02ca
  Manufacturer code: 3000
  Menu string: PCAM V4.3
00:Public resource lookup callback 3 1 1
00:CAM connecting to resource 00030041, session_number 3
00:CAM successfully connected to resource 00030041, session_number 3
00:test_ca_info_callback
  Supported CA ID: 4aa1
  Supported CA ID: 0100
  Supported CA ID: 0500
  Supported CA ID: 0600
  Supported CA ID: 0601
  Supported CA ID: 0602
  Supported CA ID: 0603
  Supported CA ID: 0604
  Supported CA ID: 0606
  Supported CA ID: 0608
  Supported CA ID: 0614
  Supported CA ID: 0620
  Supported CA ID: 0622
  Supported CA ID: 0624
  Supported CA ID: 0626
  Supported CA ID: 0628
  Supported CA ID: 0668
  Supported CA ID: 0619
  Supported CA ID: 1702
  Supported CA ID: 1722
  Supported CA ID: 1762
  Supported CA ID: 0b00
  Supported CA ID: 0b01
  Supported CA ID: 0b02
  Supported CA ID: 0d00
  Supported CA ID: 4aa0
00:Connection to resource 00030041, session_number 3 closed
00:Public resource lookup callback 3 1 1
00:CAM connecting to resource 00030041, session_number 3
00:CAM successfully connected to resource 00030041, session_number 3
00:test_ca_info_callback
  Supported CA ID: 4aa1
  Supported CA ID: 0100
  Supported CA ID: 0500
  Supported CA ID: 0600
  Supported CA ID: 0601
  Supported CA ID: 0602
  Supported CA ID: 0603
  Supported CA ID: 0604
  Supported CA ID: 0606
  Supported CA ID: 0608
  Supported CA ID: 0614
  Supported CA ID: 0620
  Supported CA ID: 0622
  Supported CA ID: 0624
  Supported CA ID: 0626
  Supported CA ID: 0628
  Supported CA ID: 0668
  Supported CA ID: 0619
  Supported CA ID: 1702
  Supported CA ID: 1722
  Supported CA ID: 1762
  Supported CA ID: 0b00
  Supported CA ID: 0b01
  Supported CA ID: 0b02
  Supported CA ID: 0d00
  Supported CA ID: 4aa0

The command doesn't quit but the streams are not descrambled.

*the third one* a second crytoworks cam
$ ./test-app 0 312
Found a CAM on adapter0... waiting...
slotid: 0
tcid: 1
Press a key to enter menu
00:Host originated transport connection 1 connected
00:Public resource lookup callback 1 1 1
00:CAM connecting to resource 00010041, session_number 1
00:CAM successfully connected to resource 00010041, session_number 1
00:Public resource lookup callback 36 1 1
00:CAM connecting to resource 00240041, session_number 2
00:CAM successfully connected to resource 00240041, session_number 2
00:test_rm_reply_callback
00:test_rm_enq_callback
00:Public resource lookup callback 2 1 1
00:CAM connecting to resource 00020041, session_number 3
00:CAM successfully connected to resource 00020041, session_number 3
00:test_datetime_enquiry_callback
  response_interval:0
00:test_ai_callback
  Application type: 01
  Application manufacturer: d000
  Manufacturer code: 0000
  Menu string: CryptoWorks
00:Public resource lookup callback 3 1 1
00:CAM connecting to resource 00030041, session_number 4
00:CAM successfully connected to resource 00030041, session_number 4
00:test_ca_info_callback
  Supported CA ID: 0d00
Error reported by stack slot:0 error:-3
^C
$


Is there any way to have more debug in order to help debugging this issue ?


Best Regards,

-- 
Pierre Gronlier


