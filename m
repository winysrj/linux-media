Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m55MUilc011405
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 18:30:44 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m55MUBbu009014
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 18:30:11 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Fri, 6 Jun 2008 00:30:03 +0200
References: <200805311720.51821.tobias.lorenz@gmx.net>
	<20080605065726.64ef79f2@gaivota>
In-Reply-To: <20080605065726.64ef79f2@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806060030.03601.tobias.lorenz@gmx.net>
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 6/6] si470x: pri... vid.. controls
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

> Also, controls not documented tend to not be implemented at userspace apps. So,
> the better is to discuss a little bit about each control you're proposing, and
> adding they at the API description (even the private ones).

The controls are documented in the data sheet, that is freely available for download: si4701-B15 Data Sheet.pdf.
So userspace apps can tend to implement them :-)

These are the parameters, that I currently implemented in private video controls (grouped):

For country selection:
- DE: De-emphasis (0=75us; 1=50us)
- BAND: Band Select (0=87.5-108MHz; 1=76-108MHz; 2=76-90MHz)
- SPACE: Channel Spacing (0=200kHz; 1=100kHz; 2=50kHz)

For (Soft)Mute/AGC/Stereo:
- DSMUTE: Softmute Disable (0=softmute enable; 1=softmute disable); this is not the same as mute.
- AGCD: AGC Disable (0=AGC enable; 1=AGC disable)
- BLNDADJ: Stereo/Mono Blend Level Adjustment (RSSI Level: 0=31-49 RSSI dBuV; 1=37-55 RSSI dBuV (+6 dB); 2=19-37 RSSI dBuV (-12 dB); 3=25-43 RSSI dBuV (-6 dB)
- SMUTER: Softmute Attack/Recover Rate (0=fastest; 1=fast; 2=slow; 3=slowest)
- SMUTEA: Softmute Attenuation (0=16 dB; 1=14 dB; 2=12 dB; 3=10 dB)

For seek configuration:
- SEEKTH: RSSI Seek Threshold
- SKSNR: Seek SNR Threshold (0=disabled; 1=max (most stops); 15=min (fewest stops))
- SKCNR: Seek FM Impulse Detection Threshold (0=disabled; 1=max (most stops); 15=min (fewest stops))

> I think that some of the controls you've added already have a non private one (for example, AGC).

At least in linux-2.6.25 non of these parameters were generally available as non private ones.
AGC was implemented as private video control in pwc and meye drivers, but was not meant for the audio behaviour, but for video behaviour.

I would propose to have one control for each of the named groups, each using a struct for the parameters.
The parameters itself should be implemented as most driver independent as possible.

For example, for country selection, which should be available by most drivers, this could look like this:
struct v4l2_radio_country_selection {
	__u8	deemphasis; // 50 or 75 (dB)
	__u32 band_lower_limit; // with respect to V4L2_TUNER_CAP_LOW
	__u32 band_upper_limit; // with respect to V4L2_TUNER_CAP_LOW
	__u32 channel_spacing; // with respect to V4L2_TUNER_CAP_LOW
}
But especially this configuration could also be implemented by extending the v4l2_tuner struct...
rangelow and rangehigh are already there. deemphasis and channel_spacing are currently missing.

I just see one general problem with the general idea upcoming:
What if a driver doesn't support the new combination of parameters?
An error should be generated and the old configuration should be kept unchanged.
So, how does an application know, which parameter combinations are valid?
Should we implement functionality to provide valid parameter combination lists or provide them with .h files? Better none of them...
Therefore the application itself has to know the characteristics of the used radio device.
But this would mean to have specific code and then we could also keep using the private controls...

Anyway, how do we proceed?
Does this changes makes sense?

Which of these parameters can be configured in other hardware and in which ranges/steps?
What do they provide more?

What are really common parameters and are they common in ranges/steps too?
Only for them it makes sense to have them as general video controls.

Bye

Toby

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
