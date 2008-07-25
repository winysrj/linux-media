Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6PB3wWL031206
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 07:03:58 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6PB3hdn008151
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 07:03:43 -0400
Received: by rv-out-0506.google.com with SMTP id f6so4111214rvb.51
	for <video4linux-list@redhat.com>; Fri, 25 Jul 2008 04:03:43 -0700 (PDT)
Message-ID: <d9def9db0807250403r3638449fl2cc5f69b29634214@mail.gmail.com>
Date: Fri, 25 Jul 2008 13:03:42 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Alan Knowles" <alan@akbkhome.com>
In-Reply-To: <4889AA61.8040006@akbkhome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48898289.2070305@akbkhome.com> <4889AA61.8040006@akbkhome.com>
Cc: video4linux-list@redhat.com
Subject: Re: ASUS My Cinema-U3100Mini/DMB-TH (Legend Slilicon 8934)
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

On Fri, Jul 25, 2008 at 12:26 PM, Alan Knowles <alan@akbkhome.com> wrote:
> Just a small update on this - I suspect ASUS released the wrong tarball for
> this device - as comparing the output from 'strings dib3000mc.ko' to the
> source code finds quite a few things missing..
>
> Waiting on a response from ASUS now.
>

after a first look over it the code seems to be a bit "inconsitent"

eg.:

+static struct mt2060_config stk3000p_adimtv102_config = {
+	(0xC2>>1)
+};

...

+	if (dvb_attach(adimtv102_attach, adap->fe, tun_i2c,
&stk3000p_adimtv102_config, if1) == NULL) {
----

whereas:
mt2060.h:

(the size of the struct is the same but the purpose of the elements
are probably not)
struct mt2060_config {
        u8 i2c_address;
        u8 clock_out; /* 0 = off, 1 = CLK/4, 2 = CLK/2, 3 = CLK/1 */
};

adimtv102.h:

struct adimtv102_config {
        u8 i2c_address;
        u8 is_through_asic;
};
#if defined(CONFIG_DVB_TUNER_ADIMTV102) ||
(defined(CONFIG_DVB_TUNER_ADIMTV102_MODULE) && defined(MODULE))
extern struct dvb_frontend * adimtv102_attach(struct dvb_frontend *fe,
struct i2c_adapter *i2c, struct adimtv102_config *cfg, u16 if1);
#else
static inline struct dvb_frontend * adimtv102_attach(struct
dvb_frontend *fe, struct i2c_adapter *i2c, struct adimtv102_config
*cfg, u16 if1)
{
        printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
        return NULL;
}

within the whole code if1 isn't needed (the adimtv102.h header is just
copied from mt2060) some cleanup still seems to be required there but
it's already a good start.

Markus

> Regards
> Alan
>
> Alan Knowles wrote:
>>
>> I've been looking at the drivers for  My Cinema-U3100Mini/DMB-TH
>>
>> The source is available directly from ASUS now.
>> http://dlcdnet.asus.com/pub/ASUS/vga/tvtuner/source_code.zip
>>
>> I've diffed it to the version they have used, and applied it, and fixed it
>> against the current source
>> http://www.akbkhome.com/svn/asus_dvb_driver/v4l-dvb-diff-from-current.diff
>>
>> In addition there are the drivers for the ADI MTV102 silicon tuner driver
>> http://www.akbkhome.com/svn/asus_dvb_driver/frontends/
>> (all the adimtv* files)
>>
>> The source code appears to use a slightly differ usb stick to the one's I
>> have.
>> 0x1748  (cold)  / 0x1749 (warm)
>> where as I've got
>> 0x1721(cold) /  0x1722 (warm)
>>
>> It looks like they hacked up dib3000mc.c, rather than writing a new driver
>>
>> I've got to the point where it builds, firmware installs etc. (firmware is
>> available inside the deb packages)
>> http://dlcdnet.asus.com/pub/ASUS/vga/tvtuner/asus-dmbth-20080528_tar.zip
>>
>> The driver initializes correctly when plugged in.
>> [302520.686782] dvb-usb: ASUSTeK DMB-TH successfully deinitialized and
>> disconnected.
>> [302530.550018] dvb-usb: found a 'ASUSTeK DMB-TH' in warm state.
>> [353408.577741] dvb-usb: will pass the complete MPEG2 transport stream to
>> the software demuxer.
>> [353408.680977] DVB: registering new adapter (ASUSTeK DMB-TH)
>> [302530.670387]  Cannot find LGS8934
>> [302530.670596] DVB: registering frontend 0 (Legend Slilicon 8934)...
>> [302530.670668] adimtv102_readreg 0x00
>> [302530.676090] adimtv102_readreg 0x01
>> [302530.681578] adimtv102_readreg 0x02
>> [302530.687077] adimtv102: successfully identified (ff ff ff)
>> [302530.688577] dvb-usb: ASUSTeK DMB-TH successfully initialized and
>> connected.
>> [302530.688624] usbcore: registered new interface driver dvb_usb_dibusb_mc
>> [353413.776593] adimtv102_init
>>
>> when w_scan is run, it outputs activity...
>> [353416.533576] lgs8934_SetAutoMode!
>> [353416.553928] lgs8934_auto_detect!
>> [353418.285686] lgs8934_auto_detect, lock 0
>> [353418.285686] adimtv102_set_params freq=184500
>> [353418.378803] MTV102>>tp->freq=184 PLLF=d8000 PLLFREQ=1472000
>>  MTV10x_REFCLK=16384 !
>> ......
>>
>> however fails to pick up any channels...
>>
>> I'm trying to connect to these -
>> http://en.wikipedia.org/wiki/Digital_television_in_Hong_Kong
>>
>> Any ideas welcome..
>>
>> Regards
>> Alan
>>
>> --
>> video4linux-list mailing list
>> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
