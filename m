Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:44897 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab0AXUJe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 15:09:34 -0500
Received: from localhost (localhost.crans.org [127.0.0.1])
	by rouge.crans.org (Postfix) with ESMTP id C24B48284
	for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 21:09:32 +0100 (CET)
Received: from rouge.crans.org ([10.231.136.3])
	by localhost (rouge.crans.org [10.231.136.3]) (amavisd-new, port 10024)
	with LMTP id NCbtO+ipX+tF for <linux-media@vger.kernel.org>;
	Sun, 24 Jan 2010 21:09:32 +0100 (CET)
Received: from [192.168.1.10] (unknown [90.163.55.116])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rouge.crans.org (Postfix) with ESMTP id 3F5E8808D
	for <linux-media@vger.kernel.org>; Sun, 24 Jan 2010 21:09:31 +0100 (CET)
Message-ID: <4B5CA8F8.3000301@crans.ens-cachan.fr>
Date: Sun, 24 Jan 2010 21:09:28 +0100
From: DUBOST Brice <dubost@crans.ens-cachan.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: problem with libdvben50221 and powercam pro V4 [almost solved]
Content-Type: multipart/mixed;
 boundary="------------030309020204090201040504"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030309020204090201040504
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hello

Powercam just made a new version of their cam, the version 4

Unfortunately this CAM doesn't work with gnutv and applications based on
libdvben50221

This cam return TIMEOUT errors (en50221_stdcam_llci_poll: Error reported
by stack:-3) after showing the supported ressource id.


I found out that this cam works with the test application of the
libdvben50221

The problem is that this camreturns two times the list of supported ids
(as shown in the log) this behavior make the llci_lookup_callback
(en50221_stdcam_llci.c line 338)  failing to give the good ressource_id
at the second call because there is already a session number (in the
test app the session number is not tested)

I solved the problem commenting out the test for the session number as
showed in the joined patch (against the latest dvb-apps, cloned today)

Since I'm not an expert of the libdvben50221, I'm asking the list if
there is better way to solve this problem and improve my patch so it can
be integrated upstream.

Thank you

-- 
Brice DUBOST

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?

--------------030309020204090201040504
Content-Type: text/x-patch;
 name="patchlibdvben50221.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patchlibdvben50221.patch"

diff -r 61b72047a995 lib/libdvben50221/en50221_stdcam_llci.c
--- a/lib/libdvben50221/en50221_stdcam_llci.c	Sun Jan 17 17:03:27 2010 +0100
+++ b/lib/libdvben50221/en50221_stdcam_llci.c	Sun Jan 24 20:56:05 2010 +0100
@@ -334,8 +334,8 @@
 					return -3;
 				break;
 			case EN50221_APP_CA_RESOURCEID:
-				if (llci->stdcam.ca_session_number != -1)
-					return -3;
+				//if (llci->stdcam.ca_session_number != -1)
+				//	return -3;
 				break;
 			case EN50221_APP_MMI_RESOURCEID:
 				if (llci->stdcam.mmi_session_number != -1)

--------------030309020204090201040504
Content-Type: text/plain;
 name="logtestapp.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="logtestapp.txt"

Found a CAM on adapter1... waiting...
en50221_tl_register_slot
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
  Menu string: PCAM V4.1
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
  Supported CA ID: 0d01
  Supported CA ID: 0d02
  Supported CA ID: 0d03
  Supported CA ID: 0d04
  Supported CA ID: 0d05
  Supported CA ID: 0d06
  Supported CA ID: 0d07
  Supported CA ID: 0d08
  Supported CA ID: 0d0c
  Supported CA ID: 0d0f
  Supported CA ID: 0d22
  Supported CA ID: 0d70
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
  Supported CA ID: 0d01
  Supported CA ID: 0d02
  Supported CA ID: 0d03
  Supported CA ID: 0d04
  Supported CA ID: 0d05
  Supported CA ID: 0d06
  Supported CA ID: 0d07
  Supported CA ID: 0d08
  Supported CA ID: 0d0c
  Supported CA ID: 0d0f
  Supported CA ID: 0d22
  Supported CA ID: 0d70
  Supported CA ID: 4aa0

00:Public resource lookup callback 64 1 1
00:CAM connecting to resource 00400041, session_number 4
00:CAM successfully connected to resource 00400041, session_number 4
00:test_mmi_display_control_callback
  cmd_id: 01
  mode: 01
00:test_mmi_menu_callback
  title: PCAM V4.1
  sub_title: 
  bottom: 
  item 1: English
  item 2: French
  item 3: Spanish
  item 4: German
  item 5: Russian
  item 6: Arabic A
  item 7: Arabic B
  raw_length: 0


--------------030309020204090201040504--
