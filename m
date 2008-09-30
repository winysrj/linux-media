Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1KkUYy-0002UN-MW
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 04:02:11 +0200
Received: by wf-out-1314.google.com with SMTP id 27so2523294wfd.17
	for <linux-dvb@linuxtv.org>; Mon, 29 Sep 2008 19:02:03 -0700 (PDT)
Message-ID: <e32e0e5d0809291902x7d18ffaep2a02384113f3d8af@mail.gmail.com>
Date: Mon, 29 Sep 2008 19:02:03 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>, "Michael Krufky" <mkrufky@linuxtv.org>,
	"linux dvb" <linux-dvb@linuxtv.org>
In-Reply-To: <48E118F5.5090501@linuxtv.org>
MIME-Version: 1.0
References: <e32e0e5d0809171545r3c2e58beh62d58fa6d04dae71@mail.gmail.com>
	<48D34C69.6050700@linuxtv.org>
	<e32e0e5d0809232045j56bef9ah1ec3ac59401de0d5@mail.gmail.com>
	<e32e0e5d0809232050s1d0257e3m30c9c055e9d32dd6@mail.gmail.com>
	<48DA9330.6070005@linuxtv.org>
	<e32e0e5d0809241315rd423c0dj553812167194d4a3@mail.gmail.com>
	<48DADA06.9000105@linuxtv.org>
	<e32e0e5d0809251807l6f0080c3j673af97821454581@mail.gmail.com>
	<e32e0e5d0809280829l690d076epe62f4d131806a65a@mail.gmail.com>
	<48E118F5.5090501@linuxtv.org>
Subject: Re: [linux-dvb] Porting analog support from HVR-1500 to the DViCO
	FusionHDTV7 Dual Express (Read this one)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0433535373=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0433535373==
Content-Type: multipart/alternative;
	boundary="----=_Part_75892_18777668.1222740123215"

------=_Part_75892_18777668.1222740123215
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Sep 29, 2008 at 11:05 AM, Steven Toth <stoth@linuxtv.org> wrote:

> Tim Lucas wrote:
>
>> On Thu, Sep 25, 2008 at 6:07 PM, Tim Lucas <lucastim@gmail.com <mailto:
>> lucastim@gmail.com>> wrote:
>>
>>    OK, so I tested both s-video and composite inputs.  I get video for
>>    s-video, but not composite.  The video seems to flicker a little bit
>>    in tv time.  I just have standard rca cables plugged in for audio,
>>    but I can;t get any sound.
>>    I tried changing the "tuner-type" to 0xc2, 0xc4, and 0x61.  All
>>    three gave the same results.
>>
>>         --Tim
>>
>>
>> So the good news was that the s-video was working.  I want to make sure
>> that I hooked up the sound correctly.  I can't imagine that there is any
>> other way than the rca cables.  So what is next?
>>
>
> That's a great step forward. That means the tv input will probably produce
> the correct input if the tuner is set correctly.
>
> Switch to this tree http://linuxtv.org/hg/~stoth/cx23885-audio and try
> again with the svideo and audio tests.
>
> Mijhail Moreyra wrote some HVR1500 audio patches, which I have not tested
> yet. Do these produce audio for you via the svideo and breakout RCA audio
> input cable?
>>
>>
>> The only things that I can adjust in cx23885-cards.c is the "tuner-type"
>>  I've tried various suggestions, but had no luck.  Are there other
>> parameters that can be changed?
>>
>
> Look at how the HVR1500 analog tuner is setup in this tree, it may help -
> especially with the tuner setup.
>
> - Steve
>

I have been using the cx23885-audio branch the entire time.  I still do not
get audio.

I have a thought about the setup. I was looking at this part of the HVR-1500
driver

.input          = {{
.type   = CX23885_VMUX_TELEVISION,
                        .vmux   =       CX25840_VIN7_CH3 |
                                        CX25840_VIN5_CH2 |
                                        CX25840_VIN2_CH1,
.gpio0  = 0,
                }, {
                        .type   = CX23885_VMUX_COMPOSITE1,
                        .vmux   =       CX25840_VIN7_CH3 |
                                        CX25840_VIN4_CH2 |
                                        CX25840_VIN6_CH1,
                        .gpio0  = 0,
                }, {
                        .type   = CX23885_VMUX_SVIDEO,
                        .vmux   =       CX25840_VIN7_CH3 |
                                        CX25840_VIN4_CH2 |
                                        CX25840_VIN8_CH1 |
                                        CX25840_SVIDEO_ON,
                        .gpio0  = 0,
                } },


The DVICO FusionHDTV5 board has the following
[CX88_BOARD_DVICO_FUSIONHDTV_5_GOLD] = {
                .name           = "DViCO FusionHDTV 5 Gold",
                .tuner_type     = TUNER_LG_TDVS_H06XF, /* TDVS-H062F */
                .radio_type     = UNSET,
                .tuner_addr     = ADDR_UNSET,
                .radio_addr     = ADDR_UNSET,
                .tda9887_conf   = TDA9887_PRESENT,
                .input          = {{
                        .type   = CX88_VMUX_TELEVISION,
                        .vmux   = 0,
                        .gpio0  = 0x87fd,
                },{
                        .type   = CX88_VMUX_COMPOSITE1,
                        .vmux   = 1,
                        .gpio0  = 0x87f9,
                },{
                        .type   = CX88_VMUX_SVIDEO,
                        .vmux   = 2,
                        .gpio0  = 0x87f9,
                }},
                .mpeg           = CX88_MPEG_DVB,
        },

Notice that .vmux and .gpio0 are set very differently.  Evidently these
values were set according to the rules

 /*

                   GPIO[0] resets DT3302 DTV receiver

                    0 - reset asserted

                    1 - normal operation

                   GPIO[1] mutes analog audio output connector

                    0 - enable selected source

                    1 - mute

                   GPIO[2] selects source for analog audio output connector

                    0 - analog audio input connector on tab

                    1 - analog DAC output from CX23881 chip

                   GPIO[3] selects RF input connector on tuner module

                    0 - RF connector labeled CABLE

                    1 - RF connector labeled ANT

                   GPIO[4] selects high RF for QAM256 mode

                    0 - normal RF

                    1 - high RF

                */

which are found in the dvico fusionhdtv 3 section.  Of course, I could just
be grasping at straws.  I have included Michael on this email to possibly
shed some light on this.  I figure that .vmux and .gpio0 have to be set
differently so that it uses settings from the dvico board, but then if I
changed those values, it wouldn't be using settings from the cx25840 driver.


-- 
    --Tim

------=_Part_75892_18777668.1222740123215
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div class="gmail_quote">On Mon, Sep 29, 2008 at 11:05 AM, Steven Toth <span dir="ltr">&lt;<a href="mailto:stoth@linuxtv.org">stoth@linuxtv.org</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
Tim Lucas wrote:<div class="Ih2E3d"><br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
On Thu, Sep 25, 2008 at 6:07 PM, Tim Lucas &lt;<a href="mailto:lucastim@gmail.com" target="_blank">lucastim@gmail.com</a> &lt;mailto:<a href="mailto:lucastim@gmail.com" target="_blank">lucastim@gmail.com</a>&gt;&gt; wrote:<br>

<br>
 &nbsp; &nbsp;OK, so I tested both s-video and composite inputs. &nbsp;I get video for<br>
 &nbsp; &nbsp;s-video, but not composite. &nbsp;The video seems to flicker a little bit<br>
 &nbsp; &nbsp;in tv time. &nbsp;I just have standard rca cables plugged in for audio,<br>
 &nbsp; &nbsp;but I can;t get any sound.<br>
 &nbsp; &nbsp;I tried changing the &quot;tuner-type&quot; to 0xc2, 0xc4, and 0x61. &nbsp;All<br>
 &nbsp; &nbsp;three gave the same results.<br>
<br>
 &nbsp; &nbsp; &nbsp; &nbsp; --Tim<br>
<br>
<br>
So the good news was that the s-video was working. &nbsp;I want to make sure that I hooked up the sound correctly. &nbsp;I can&#39;t imagine that there is any other way than the rca cables. &nbsp;So what is next?<br>
</blockquote>
<br></div>
That&#39;s a great step forward. That means the tv input will probably produce the correct input if the tuner is set correctly.<br>
<br>
Switch to this tree <a href="http://linuxtv.org/hg/~stoth/cx23885-audio" target="_blank">http://linuxtv.org/hg/~stoth/cx23885-audio</a> and try again with the svideo and audio tests.<br>
<br>
Mijhail Moreyra wrote some HVR1500 audio patches, which I have not tested yet. Do these produce audio for you via the svideo and breakout RCA audio input cable?<div class="Ih2E3d"><blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
The only things that I can adjust in cx23885-cards.c is the &quot;tuner-type&quot; &nbsp;I&#39;ve tried various suggestions, but had no luck. &nbsp;Are there other parameters that can be changed? &nbsp;<br>
</blockquote>
<br></div>
Look at how the HVR1500 analog tuner is setup in this tree, it may help - especially with the tuner setup.<br>
<br>
- Steve<br>
</blockquote></div><div><br></div><div>I have been using the cx23885-audio branch the entire time. &nbsp;I still do not get audio.<br></div><div><br></div><div>I have a thought about the setup. I was looking at this part of the HVR-1500 driver</div>
<div><br></div><div><div>.input &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;= {{</div><div><span class="Apple-tab-span" style="white-space:pre">			</span>.type &nbsp; = CX23885_VMUX_TELEVISION,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = &nbsp; &nbsp; &nbsp; CX25840_VIN7_CH3 |</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN5_CH2 |</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN2_CH1,</div><div><span class="Apple-tab-span" style="white-space:pre">			</span>.gpio0 &nbsp;= 0,</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}, {</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX23885_VMUX_COMPOSITE1,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = &nbsp; &nbsp; &nbsp; CX25840_VIN7_CH3 |</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN4_CH2 |</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN6_CH1,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}, {</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX23885_VMUX_SVIDEO,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = &nbsp; &nbsp; &nbsp; CX25840_VIN7_CH3 |</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN4_CH2 |</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN8_CH1 |</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_SVIDEO_ON,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0,</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;} },</div><div><br></div></div><br>The DVICO FusionHDTV5 board has the following<div><br></div><div><div><div>[CX88_BOARD_DVICO_FUSIONHDTV_5_GOLD] = {</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.name &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; = &quot;DViCO FusionHDTV 5 Gold&quot;,</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tuner_type &nbsp; &nbsp; = TUNER_LG_TDVS_H06XF, /* TDVS-H062F */</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.radio_type &nbsp; &nbsp; = UNSET,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tuner_addr &nbsp; &nbsp; = ADDR_UNSET,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.radio_addr &nbsp; &nbsp; = ADDR_UNSET,</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tda9887_conf &nbsp; = TDA9887_PRESENT,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.input &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;= {{</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX88_VMUX_TELEVISION,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = 0,</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0x87fd,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},{</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX88_VMUX_COMPOSITE1,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = 1,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0x87f9,</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;},{</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX88_VMUX_SVIDEO,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = 2,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0x87f9,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}},</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.mpeg &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; = CX88_MPEG_DVB,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;},</div><div><br></div><div>Notice that .vmux and .gpio0 are set very differently. &nbsp;Evidently these values were set according to the rules</div><div>
<br></div><div><div>&nbsp;/* &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; GPIO[0] resets DT3302 DTV receiver &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 - reset asserted &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1 - normal operation &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; GPIO[1] mutes analog audio output connector &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 - enable selected source &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1 - mute &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; GPIO[2] selects source for analog audio output connector &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 - analog audio input connector on tab &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1 - analog DAC output from CX23881 chip &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; GPIO[3] selects RF input connector on tuner module &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 - RF connector labeled CABLE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1 - RF connector labeled ANT &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; GPIO[4] selects high RF for QAM256 mode &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 - normal RF &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1 - high RF &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*/</div><div><br></div></div><div>which are found in the dvico fusionhdtv 3 section. &nbsp;Of course, I could just be grasping at straws. &nbsp;I have included Michael on this email to possibly shed some light on this. &nbsp;I figure that .vmux and .gpio0 have to be set differently so that it uses settings from the dvico board, but then if I changed those values, it wouldn&#39;t be using settings from the cx25840 driver. &nbsp; &nbsp;<br>
<br></div><div>-- <br> &nbsp; &nbsp; --Tim<br>
</div></div></div></div>

------=_Part_75892_18777668.1222740123215--


--===============0433535373==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0433535373==--
