Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab3AQQvV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 11:51:21 -0500
Date: Thu, 17 Jan 2013 14:50:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130117145036.55745a60@redhat.com>
In-Reply-To: <50F7C57A.6090703@iki.fi>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<20130116200153.3ec3ee7d@redhat.com>
	<CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com>
	<50F7C57A.6090703@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Jan 2013 11:33:46 +0200
Antti Palosaari <crope@iki.fi> escreveu:
 
> What goes to these units in general, dB conversion is done by the driver 
> about always. It is quite hard or even impossible to find out that 
> formula unless you has adjustable test signal generator.
> 
> Also we could not offer always dBm as signal strength. This comes to 
> fact that only recent silicon RF-tuners are able to provide RF strength. 
> More traditionally that estimation is done by demod from IF/RF AGC, 
> which leads very, very, rough estimation.
>
> So at least for the signal strength it is impossible to require dBm. dB 
> for SNR is possible, but it is very hard due to lack of developers 
> knowledge and test equipment. SNR could be still forced to look like it 
> is in given dB scale. I think it is not big loss even though SNR values 
> reported are a little bit wrong.
> 
> 
> About half year ago I looked how SNR was measured every demod we has:
> 
> http://palosaari.fi/linux/v4l-dvb/snr_2012-05-21.txt
> 
> as we can see there is currently only two style used:
> 1) 0.1 dB (very common in new drivers)
> 2) unknown (== mostly just raw register values)

It could make sense to have an FE_SCALE_UNKNOWN for those drivers, if
they can't converted into any of the supported scales.

Btw, as agreed, on v11:
	- dB scale changed to 0.001 dB (not sure if this will bring much
gain, as I doubt that demods have that much precision);
	- removed QoS nomenclature (I hope I didn't forget it left on
	  some patch);
	- removed DTV_QOS_ENUM;
	- counters reset logic is now driver-specific (currently, resetting
	  it at set_frontend callback on mb8620s);

I'll be posting the patches after finishing the tests.

What's left (probably we need more discussions):

a) a flag to indicate a counter reset (my suggestion). 

Does it make sense? If so, where should it be? At fe_status_t?

b) per-stats/per-dvb-property error indicator (Devin's suggestion).

I don't think it is needed for statistics. Yet, it may be interesting for
the other dvb properties.

So, IMHO, I would do add it like:

struct dtv_property {
        __u32 cmd;
	__s32 error;		/* Linux error code when set/get this specific property */
        __u32 reserved[2];
        union {
                __u32 data;
                struct dtv_fe_stats st;
                struct {
                        __u8 data[32];
                        __u32 len;
                        __u32 reserved1[3];
                        void *reserved2;
               	} buffer;
        } u;
        int result;
} __attribute__ ((packed));

A patch adding this for statistics should be easy, as there's just one
driver currently implementing it. Making the core and drivers handle 
per-property errors can be trickier and will require more work.

But I'm still in doubt if it does make sense for stats. 

Devin?

Cheers,
Mauro
