Return-path: <linux-media-owner@vger.kernel.org>
Received: from email.brin.com ([208.89.164.15]:52652 "EHLO email.brin.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbZCJUOV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 16:14:21 -0400
Received: from email.brin.com (email.brin.com [172.19.1.12])
	by email.brin.com (Postfix) with ESMTP id EA045798001
	for <linux-media@vger.kernel.org>; Tue, 10 Mar 2009 14:03:10 -0600 (MDT)
Date: Tue, 10 Mar 2009 14:03:10 -0600 (MDT)
From: Bob Ingraham <bobi@brin.com>
To: linux-media@vger.kernel.org
Message-ID: <824146004.72331236715390866.JavaMail.root@email>
Subject: How to utilize DVB Network API
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello All,

The documentation leaves the Network section of the API as "To be written..."

I've looked at the header file, and it may be straightforward to call, but...

Does anyone know how to properly invoke this part of the API?

Is it correct to assume that the point of the network API is to create a "virtual" network interface that I can treat like any other NIC (unidirectional, of course)?

My goal is to receive multicast packets using a Skystar 2 DVB-S card (rev 2.6), using standard multicast join and UDP receive calls.

The dvb_net_if structure has the following fields:

        __u16 pid;      // This is obvious
        __u16 if_num;   // Don't know exactly what goes here???
        __u8  feedtype; // This is either 0 (MPE) or 1 (ULE)

For example, does the following code snippet the proper way to go about this?

struct dbv_net_if dni;
int sd;

dni.pid = 3022;  // My MPEG2 PID
dni.if_num = 0;  // ???
dni.feedtype = DVB_NET_FEEDTYPE_MPE;

sd = open("/dev/dvb/adapter0/net0", O_RDONLY);
ioctl(sd, NET_ADD_IF, &dni);

Now, do I read packets from /dev/dvb/adapter0/net0 using my sd descriptor?

Or do I at this point open a standard UDP socket and start listening for packets from the satellite interface?

Any help in clearing my basic confusion would be much appreciated.

Thank-you!

Bob
