Return-path: <linux-media-owner@vger.kernel.org>
Received: from txslsmtp2.vzwmail.net ([66.174.85.156]:44429 "EHLO
	txslsmtp2.vzwmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbZAVS4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 13:56:35 -0500
Received: from [75.216.236.54] (smtp.vzwmail.net [66.174.85.25])
	(authenticated bits=0)
	by txslsmtp2.vzwmail.net (8.12.9/8.12.9) with ESMTP id n0MIuITh016031
	for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 18:56:30 GMT
Message-ID: <4978C17B.2050909@vzwmail.net>
Date: Thu, 22 Jan 2009 11:56:59 -0700
From: "T.P. Reitzel" <4066724035@vzwmail.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: gspca_spca505
Content-Type: multipart/mixed;
 boundary="------------030704060909090702060809"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030704060909090702060809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ooops! ;) I'm having some visual problems so you'll have to bear with me 
for the next few months. OK, I copy and pasted your debug level of 63, 
yes 63, into the echo command and outputted the result of svv -rg from 
dmesg into the file, kernel.txt. I did NOT detach and reattach the 
camera in this latter case.  For the time being, I'm leaving my e-mail 
address alone. I will change it in time. You can reach me at 
t,p,r'e'i,t.z,e'l AT  hotmail.com. Naturally, omit the punctuation in my 
id.

Your listed echo command should output to .../module/... not 
.../modules/... Also, my system doesn't have a kern.log so I used dmesg 
| grep spca instead and outputted the result to kernel.txt

Furthermore, I noticed after my last correspondence that the camera 
works perfectly when I powered the system off for approximately 10 
seconds and rebooted. The FIRST attempt to run svv  worked flawlessly. 
After exiting svv and trying again, the video was garbled from that 
point onward so it might be an initialization problem. I have NOT tried 
to recompile spca505.c with the change yet. I'll wait until I hear from 
you again via  my address at hotmail.com

Also, I clearly remember when M. Xhaard revamped the spca5xx driver a 
few years ago. When he did, the internal capture card stopped working. I 
even e-mailed M. about the problem, but nothing positive resulted from it.



--------------030704060909090702060809
Content-Type: text/plain;
 name="kernel.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel.txt"

gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: packet [3] o:3069 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: packet [8] o:8184 l:1023
gspca: packet [9] o:9207 l:1023
gspca: packet [10] o:10230 l:1023
gspca: packet [11] o:11253 l:1023
gspca: packet [12] o:12276 l:1023
gspca: packet [13] o:13299 l:1023
gspca: packet [14] o:14322 l:1023
gspca: packet [15] o:15345 l:1023
gspca: packet [16] o:16368 l:1023
gspca: packet [17] o:17391 l:1023
gspca: packet [18] o:18414 l:1023
gspca: packet [19] o:19437 l:1023
gspca: packet [20] o:20460 l:1023
gspca: packet [21] o:21483 l:1023
gspca: packet [22] o:22506 l:1023
gspca: packet [23] o:23529 l:1023
gspca: packet [24] o:24552 l:1023
gspca: packet [25] o:25575 l:1023
gspca: packet [26] o:26598 l:1023
gspca: packet [27] o:27621 l:1023
gspca: packet [28] o:28644 l:1023
gspca: packet [29] o:29667 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [30] o:30690 l:1023
gspca: packet [31] o:31713 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: packet [3] o:3069 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: packet [8] o:8184 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: packet [3] o:3069 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: packet [8] o:8184 l:1023
gspca: packet [9] o:9207 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: packet [3] o:3069 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: poll
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: packet [8] o:8184 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: packet [3] o:3069 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:3 o:3
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:3 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:3 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:3 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:3 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:3 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:3 o:2
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:3 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:3 o:3
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: packet [8] o:8184 l:1023
gspca: packet [9] o:9207 l:1023
gspca: packet [10] o:10230 l:1023
gspca: packet [11] o:11253 l:1023
gspca: packet [12] o:12276 l:1023
gspca: packet [13] o:13299 l:1023
gspca: packet [14] o:14322 l:1023
gspca: packet [15] o:15345 l:1023
gspca: packet [16] o:16368 l:1023
gspca: packet [17] o:17391 l:1023
gspca: packet [18] o:18414 l:1023
gspca: packet [19] o:19437 l:1023
gspca: packet [20] o:20460 l:1023
gspca: packet [21] o:21483 l:1023
gspca: packet [22] o:22506 l:1023
gspca: packet [23] o:23529 l:1023
gspca: packet [24] o:24552 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [25] o:25575 l:1023
gspca: packet [26] o:26598 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:0 o:3
gspca: add t:1 l:1013
gspca: packet [27] o:27621 l:1023
gspca: packet [28] o:28644 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:1 o:3
gspca: add t:1 l:1013
gspca: packet [29] o:29667 l:1023
gspca: packet [30] o:30690 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:3 i:2 o:3
gspca: add t:1 l:1013
gspca: packet [31] o:31713 l:1023
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: packet [3] o:3069 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:2 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:2 o:3
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: packet [8] o:8184 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:2 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:2 o:3
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:2 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:2 o:3
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:2 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:2 o:3
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:2 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:2 o:3
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: packet [3] o:3069 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: packet [8] o:8184 l:1023
gspca: packet [9] o:9207 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:2 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:2 o:3
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:2 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:2 o:3
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:2 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:2 o:3
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: packet [8] o:8184 l:1023
gspca: packet [9] o:9207 l:1023
gspca: packet [10] o:10230 l:1023
gspca: packet [11] o:11253 l:1023
gspca: packet [12] o:12276 l:1023
gspca: packet [13] o:13299 l:1023
gspca: packet [14] o:14322 l:1023
gspca: packet [15] o:15345 l:1023
gspca: packet [16] o:16368 l:1023
gspca: packet [17] o:17391 l:1023
gspca: packet [18] o:18414 l:1023
gspca: packet [19] o:19437 l:1023
gspca: packet [20] o:20460 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [21] o:21483 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [22] o:22506 l:1023
gspca: packet [23] o:23529 l:1023
gspca: packet [24] o:24552 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [25] o:25575 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [26] o:26598 l:1023
gspca: packet [27] o:27621 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:2 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:2 o:3
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: packet [2] o:2046 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [3] o:3069 l:1023
gspca: packet [4] o:4092 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [5] o:5115 l:1023
gspca: packet [6] o:6138 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [7] o:7161 l:1023
gspca: packet [8] o:8184 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
gspca: poll
gspca: dqbuf
gspca: frame wait q:2 i:2 o:3
gspca: dqbuf 2
gspca: qbuf 2
gspca: qbuf q:3 i:2 o:3
gspca: poll
gspca: dqbuf
gspca: frame wait q:3 i:2 o:0
gspca: dqbuf 3
gspca: qbuf 3
gspca: qbuf q:0 i:2 o:0
gspca: poll
gspca: dqbuf
gspca: frame wait q:0 i:2 o:1
gspca: dqbuf 0
gspca: qbuf 0
gspca: qbuf q:1 i:2 o:1
gspca: poll
gspca: dqbuf
gspca: frame wait q:1 i:2 o:2
gspca: dqbuf 1
gspca: qbuf 1
gspca: qbuf q:2 i:2 o:2
gspca: poll
gspca: isoc irq
gspca: packet [0] o:0 l:1023
gspca: add t:3 l:0
gspca: add t:1 l:1013
gspca: packet [1] o:1023 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:3 o:2
gspca: add t:1 l:1013
gspca: packet [2] o:2046 l:1023
gspca: packet [3] o:3069 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:0 o:2
gspca: add t:1 l:1013
gspca: packet [4] o:4092 l:1023
gspca: packet [5] o:5115 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:1 o:2
gspca: add t:1 l:1013
gspca: packet [6] o:6138 l:1023
gspca: packet [7] o:7161 l:1023
gspca: add t:3 l:0
gspca: frame complete len:1013 q:2 i:2 o:2
gspca: add t:1 l:1013
spca505: reg write: 0x02,0x00:0x00, 0x0
gspca: kill transfer
gspca: isoc irq
gspca: isoc irq
spca505: reg write: 0x03,0x03:0x20, 0x0
spca505: reg write: 0x03,0x01:0x00, 0x0
spca505: reg write: 0x03,0x00:0x01, 0x0
spca505: reg write: 0x05,0x10:0x01, 0x0
spca505: reg write: 0x05,0x11:0x0f, 0x0
gspca: stream off OK
gspca: svv close
gspca: frame free
gspca: close done

--------------030704060909090702060809
Content-Type: application/octet-stream;
 name="image.dat"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="image.dat"

AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
--------------030704060909090702060809--
