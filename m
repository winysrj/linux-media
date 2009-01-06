Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from alsikeapila.uta.fi ([153.1.1.44])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pauli@borodulin.fi>) id 1LKAos-0003O9-Bs
	for linux-dvb@linuxtv.org; Tue, 06 Jan 2009 13:14:03 +0100
Received: from valkoapila.uta.fi (valkoapila.uta.fi [153.1.1.42])
	by alsikeapila.uta.fi (8.13.8/8.13.8) with ESMTP id n06CDvlS015911
	for <linux-dvb@linuxtv.org>; Tue, 6 Jan 2009 14:13:57 +0200 (EET)
Received: from apila.uta.fi (localhost.localdomain [127.0.0.1])
	by valkoapila.uta.fi (8.13.8/8.13.8) with ESMTP id n06CDvhq018862
	for <linux-dvb@linuxtv.org>; Tue, 6 Jan 2009 14:13:57 +0200
Received: from [10.0.0.250] (une.tontut.fi [193.166.93.36])
	(authenticated bits=0)
	by apila.uta.fi (8.14.1/8.14.1) with ESMTP id n06CDuUd008301
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Tue, 6 Jan 2009 14:13:56 +0200 (EET)
Message-ID: <49634AFE.2080405@borodulin.fi>
Date: Tue, 06 Jan 2009 14:13:50 +0200
From: Pauli Borodulin <pauli@borodulin.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] The status and future of Mantis driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Heya!

I found out that there is some new activity on Manu Abraham's Mantis 
driver, so I thought I could throw in some thoughts about it.

I have been using Manu's Mantis driver (http://www.jusst.de/hg/mantis) 
for over two years now. I have a VP-2033 card (DVB-C) and at least for 
the last year the driver has worked without any hickups in my daily 
(VDR) use. For a long time I have thought that the driver should already 
be merged to the v4l-dvb tree.

Igor M. Liplianin has created a new tree 
(http://mercurial.intuxication.org/hg/s2-liplianin) with the description 
"DVB-S(S2) drivers for Linux". Mantis driver was merged into the tree in 
October and since then some fixes has also been applied to the driver. 
Some of these fixes already exist in Manu's tree, some don't. Both trees 
are missing the remote control support for VP-2033 and VP-2040.

Until merging of the driver into s2-liplianin, there was a single tree 
for the Mantis driver development. Now that there are two trees, I fear 
that the development could scatter if there's no clear idea how the 
driver is going to get into v4l-dvb. Also, the driver is not only 
DVB-S(S2), but it also contains support for VP-2033 (DVB-C), VP-2040 
(DVB-C) and VP-3030 (DVB-T). DVB-S(S2) stuff will probably greatly(?) 
delay getting the support for DVB-C/T Mantis cards into v4l-dvb.

For my personal use I have created a patch against the latest v4l-dvb 
based on Manu's Mantis tree including the remote control support for 
VP-2033 and VP-2040. But what I would really like to see is Mantis 
driver merged into v4l-dvb and later into mainstream.

Igor, what are your thoughts about the Mantis driver? How about the 
other Mantis users, like Marko Ristola, Roland Scheidegger, and Kristian 
Slavov?

Regards,
Pauli Borodulin

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
