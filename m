Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <hfvogt@gmx.net>) id 1Jq49x-000699-PF
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 12:31:06 +0200
From: Hans-Frieder Vogt <hfvogt@gmx.net>
To: linux-dvb@linuxtv.org
Date: Sun, 27 Apr 2008 12:30:25 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804271230.25278.hfvogt@gmx.net>
Subject: [linux-dvb] xc2028-tuner: current cvs/hg code broken?
Reply-To: hfvogt@gmx.net
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

Hi list,

trying to get the DVICO FusionHDTV Dual Express running with the current v4l-dvb development tree, I ran continuously into kernel oops.
When I traced these back I found, that tuner-xc2028.c must have been changed recently (OK, sometime between the 9th march and the 22th april) and makes several drivers fail as a consequence.

In the tuner-xc2028.c from the 9th march snapshot, in xc2028_attach the definition of video_dev was:
video_dev = cfg->video_dev;
In current v4l-dvb snapshots, it is defined as
video_dev = cfg->i2c_adap->algo_data;

=> any video_dev definition in a struct xc2028_config is without any effect! Therefore any driver that relies on video_dev to be as set in the xc2028_config will run into trouble as soon as the tuner_callback is called.

it seems, that the problem raised in http://www.linuxtv.org/pipermail/linux-dvb/2008-March/025076.html could be related.

I completely missed that change in the mailing list.

Can anybody please point me to a explanation or discussion of that change? If we intend to leave the definition of video_dev in tuner-xc2028.c as it is currently, wouldn't it be then a good idea to remove the video_dev field in structure xc2028_config, to force all drivers which may rely on that field to be reviewed?

Thanks,
Hans-Frieder

-- 
--
Hans-Frieder Vogt                 e-mail: hfvogt <at> gmx .dot. net

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
