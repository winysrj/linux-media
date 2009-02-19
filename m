Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:17093 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbZBSCTS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 21:19:18 -0500
Received: by an-out-0708.google.com with SMTP id c2so87294anc.1
        for <linux-media@vger.kernel.org>; Wed, 18 Feb 2009 18:19:15 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 18 Feb 2009 20:19:15 -0600
Message-ID: <1767e6740902181819i9982865u1dec75b5f337b8a4@mail.gmail.com>
Subject: Kworld atsc 110 nxt2004 init
From: Jonathan Isom <jeisom@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
I was looking over my logs and I'm wondering is
"nxt200x: Timeout waiting for nxt2004 to init"
common or is this womething I need to worry about.  I got one shortly before a
lockup(No backtrace).  Nothing was doing other than dvbstreamer sitting idle.
I'll provide further logs if it should be needed.  I would think that
It would need to
only be initialize at module load.  Am I wrong in this thinking?

in kernel  drivers 2.6.28.4

Later

Jonathan

-------------   grep -rn nxt2004 /var/log/messages
------------------------------
103679:Feb 18 11:29:35 ravage [    7.925156] nxt2004: Waiting for
firmware upload (dvb-fe-nxt2004.fw)...
103680:Feb 18 11:29:35 ravage [    7.925166] i2c-adapter i2c-1:
firmware: requesting dvb-fe-nxt2004.fw
103681:Feb 18 11:29:35 ravage [    8.072591] nxt2004: Waiting for
firmware upload(2)...
103692:Feb 18 11:29:35 ravage [    9.256867]  sdc:nxt2004: Firmware
upload complete
103719:Feb 18 11:29:35 ravage [   10.109159] nxt2004: Waiting for
firmware upload (dvb-fe-nxt2004.fw)...
103720:Feb 18 11:29:35 ravage [   10.109169] i2c-adapter i2c-2:
firmware: requesting dvb-fe-nxt2004.fw
103721:Feb 18 11:29:35 ravage [   10.129386] nxt2004: Waiting for
firmware upload(2)...
103734:Feb 18 11:29:35 ravage [   11.495301] nxt2004: Firmware upload complete
103906:Feb 18 14:06:04 ravage [ 9402.688185] nxt200x: Timeout waiting
for nxt2004 to init.
103907:Feb 18 14:06:33 ravage [ 9431.488278] nxt200x: Timeout waiting
for nxt2004 to init.
103908:Feb 18 14:07:19 ravage [ 9478.214280] nxt200x: Timeout waiting
for nxt2004 to init.
103918:Feb 18 14:29:02 ravage [10776.540206] nxt200x: Timeout waiting
for nxt2004 to init.
103922:Feb 18 14:36:28 ravage [11222.734776] nxt200x: Timeout waiting
for nxt2004 to init.
103926:Feb 18 14:41:53 ravage [11547.926210] nxt200x: Timeout waiting
for nxt2004 to init.
103930:Feb 18 14:43:21 ravage [11632.944024] nxt200x: Timeout waiting
for nxt2004 to init.
103939:Feb 18 15:02:17 ravage [12767.392184] nxt200x: Timeout waiting
for nxt2004 to init.
103940:Feb 18 15:02:59 ravage [12809.110280] nxt200x: Timeout waiting
for nxt2004 to init.
103943:Feb 18 15:12:55 ravage [13404.641143] nxt200x: Timeout waiting
for nxt2004 to init.
103964:Feb 18 15:50:57 ravage [15680.490276] nxt200x: Timeout waiting
for nxt2004 to init.
103966:Feb 18 15:52:52 ravage [15795.494281] nxt200x: Timeout waiting
for nxt2004 to init.
103970:Feb 18 15:57:31 ravage [16074.085281] nxt200x: Timeout waiting
for nxt2004 to init.
104026:Feb 18 16:12:33 ravage [16974.415323] nxt200x: Timeout waiting
for nxt2004 to init.
104027:Feb 18 16:13:47 ravage [17047.839276] nxt200x: Timeout waiting
for nxt2004 to init.
104028:Feb 18 16:14:43 ravage [17104.320278] nxt200x: Timeout waiting
for nxt2004 to init.
104030:Feb 18 16:17:04 ravage [17243.163280] nxt200x: Timeout waiting
for nxt2004 to init.
104034:Feb 18 16:23:20 ravage [17618.900281] nxt200x: Timeout waiting
for nxt2004 to init.
104040:Feb 18 16:30:14 ravage [18032.751279] nxt200x: Timeout waiting
for nxt2004 to init.
104043:Feb 18 16:33:09 ravage [18205.866294] nxt200x: Timeout waiting
for nxt2004 to init.
104045:Feb 18 16:39:47 ravage [18603.418279] nxt200x: Timeout waiting
for nxt2004 to init.
104052:Feb 18 16:52:59 ravage [19393.899278] nxt200x: Timeout waiting
for nxt2004 to init.
104055:Feb 18 16:59:10 ravage [19764.901340] nxt200x: Timeout waiting
for nxt2004 to init.
104056:Feb 18 16:59:12 ravage [19765.942278] nxt200x: Timeout waiting
for nxt2004 to init.
104061:Feb 18 17:01:06 ravage [19880.749187] nxt200x: Timeout waiting
for nxt2004 to init.
104063:Feb 18 17:02:52 ravage [19984.340281] nxt200x: Timeout waiting
for nxt2004 to init.
104064:Feb 18 17:03:08 ravage [20000.528331] nxt200x: Timeout waiting
for nxt2004 to init.
104065:Feb 18 17:06:23 ravage [20194.971280] nxt200x: Timeout waiting
for nxt2004 to init.
104066:Feb 18 17:08:17 ravage [20309.528164] nxt200x: Timeout waiting
for nxt2004 to init.
104067:Feb 18 17:09:50 ravage [20401.883279] nxt200x: Timeout waiting
for nxt2004 to init.
104070:Feb 18 17:10:38 ravage [20450.212281] nxt200x: Timeout waiting
for nxt2004 to init.
104072:Feb 18 17:12:44 ravage [20576.170276] nxt200x: Timeout waiting
for nxt2004 to init.
104073:Feb 18 17:12:47 ravage [20579.282277] nxt200x: Timeout waiting
for nxt2004 to init.
104074:Feb 18 17:15:15 ravage [20727.081029] nxt200x: Timeout waiting
for nxt2004 to init.
104075:Feb 18 17:17:15 ravage [20847.849278] nxt200x: Timeout waiting
for nxt2004 to init.
104077:Feb 18 17:19:58 ravage [21008.039030] nxt200x: Timeout waiting
for nxt2004 to init.
104088:Feb 18 17:39:31 ravage [22178.802143] nxt200x: Timeout waiting
for nxt2004 to init.
104095:Feb 18 17:50:18 ravage [22823.847322] nxt200x: Timeout waiting
for nxt2004 to init.
104097:Feb 18 17:54:07 ravage [23053.062140] nxt200x: Timeout waiting
for nxt2004 to init.
104105:Feb 18 18:07:12 ravage [23835.194357] nxt200x: Timeout waiting
for nxt2004 to init.
104108:Feb 18 18:10:15 ravage [24018.519280] nxt200x: Timeout waiting
for nxt2004 to init.
104109:Feb 18 18:11:51 ravage [24114.077230] nxt200x: Timeout waiting
for nxt2004 to init.
104112:Feb 18 18:19:33 ravage [24576.718280] nxt200x: Timeout waiting
for nxt2004 to init.
104115:Feb 18 18:23:16 ravage [24797.646283] nxt200x: Timeout waiting
for nxt2004 to init.
104116:Feb 18 18:23:21 ravage [24802.409279] nxt200x: Timeout waiting
for nxt2004 to init.
104117:Feb 18 18:24:05 ravage [24846.749278] nxt200x: Timeout waiting
for nxt2004 to init.
104120:Feb 18 18:34:16 ravage [25457.200186] nxt200x: Timeout waiting
for nxt2004 to init.
104121:Feb 18 18:35:40 ravage [25541.022144] nxt200x: Timeout waiting
for nxt2004 to init.
104123:Feb 18 18:36:21 ravage [25580.199276] nxt200x: Timeout waiting
for nxt2004 to init.
104126:Feb 18 18:41:33 ravage [25892.056279] nxt200x: Timeout waiting
for nxt2004 to init.
104127:Feb 18 18:42:02 ravage [25920.600323] nxt200x: Timeout waiting
for nxt2004 to init.
104129:Feb 18 18:45:30 ravage [26128.720286] nxt200x: Timeout waiting
for nxt2004 to init.
104131:Feb 18 18:48:22 ravage [26300.799155] nxt200x: Timeout waiting
for nxt2004 to init.
104132:Feb 18 18:48:29 ravage [26308.127280] nxt200x: Timeout waiting
for nxt2004 to init.
104137:Feb 18 18:56:40 ravage [26797.160332] nxt200x: Timeout waiting
for nxt2004 to init.
104146:Feb 18 19:06:03 ravage [27359.499280] nxt200x: Timeout waiting
for nxt2004 to init.
104148:Feb 18 19:09:33 ravage [27568.026286] nxt200x: Timeout waiting
for nxt2004 to init.
104149:Feb 18 19:09:37 ravage [27571.821281] nxt200x: Timeout waiting
for nxt2004 to init.
104152:Feb 18 19:15:37 ravage [27931.659277] nxt200x: Timeout waiting
for nxt2004 to init.
104153:Feb 18 19:19:31 ravage [28165.965284] nxt200x: Timeout waiting
for nxt2004 to init.
104155:Feb 18 19:20:25 ravage [28219.370282] nxt200x: Timeout waiting
for nxt2004 to init.
104162:Feb 18 19:30:05 ravage [28797.528280] nxt200x: Timeout waiting
for nxt2004 to init.
104168:Feb 18 19:38:21 ravage [29290.928346] nxt200x: Timeout waiting
for nxt2004 to init.
104170:Feb 18 19:40:10 ravage [29400.053281] nxt200x: Timeout waiting
for nxt2004 to init.
104171:Feb 18 19:40:14 ravage [29404.195325] nxt200x: Timeout waiting
for nxt2004 to init.
104178:Feb 18 19:48:21 ravage [29891.230014] nxt200x: Timeout waiting
for nxt2004 to init.
----------------------------
--------------------------------------------------------------------
ASUS m3a78 mothorboard
AMD Athlon64 X2 Dual Core Processor 6000+ 3.1Ghz
Gigabyte NVidia 9400gt  Graphics adapter
Kworld ATSC 110 TV Capture Card
Kworld ATSC 115 TV Capture Card
--------------------------------------------------------------------
