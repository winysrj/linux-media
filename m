Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm4.telefonica.net ([213.4.138.20]:12941 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754577Ab3CXTjb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 15:39:31 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Antti Palosaari <crope@iki.fi>
Cc: Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] block i2c tuner reads for Avermedia Twinstar in the af9035 driver
Date: Sun, 24 Mar 2013 20:39:15 +0100
Message-ID: <1602162.t6BDYGs1VX@jar7.dominio>
In-Reply-To: <5146399E.8070404@iki.fi>
References: <4261811.IXtDYhFBCx@jar7.dominio> <2056426.oO4bCijko2@jar7.dominio> <5146399E.8070404@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Domingo, 17 de marzo de 2013 23:46:06 Antti Palosaari escribió:
> On 03/17/2013 08:49 PM, Jose Alberto Reguero wrote:
> > On Martes, 12 de marzo de 2013 00:11:38 Antti Palosaari escribió:
> >> On 03/11/2013 10:02 PM, Jose Alberto Reguero wrote:
> >>> On Lunes, 11 de marzo de 2013 14:57:37 Antti Palosaari escribió:
> >>>> On 03/11/2013 01:51 PM, Jose Alberto Reguero wrote:
> >>>>> On Lunes, 11 de febrero de 2013 14:48:18 Jose Alberto Reguero 
escribió:
> >>>>>> On Domingo, 10 de febrero de 2013 22:11:53 Antti Palosaari escribió:
> >>>>>>> On 02/10/2013 09:43 PM, Jose Alberto Reguero wrote:
> >>>>>>>> This patch block the i2c tuner reads for Avermedia Twinstar. If
> >>>>>>>> it's
> >>>>>>>> needed other pids can be added.
> >>>>>>>> 
> >>>>>>>> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
> >>>>>>>> 
> >>>>>>>> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c
> >>>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.c ---
> >>>>>>>> linux/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-07
> >>>>>>>> 05:45:57.000000000 +0100 +++
> >>>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2013-02-08
> >>>>>>>> 22:55:08.304089054 +0100 @@ -232,7 +232,11 @@ static int
> >>>>>>>> af9035_i2c_master_xfer(struct
> >>>>>>>> 
> >>>>>>>>      			buf[3] = 0x00; /* reg addr MSB */
> >>>>>>>>      			buf[4] = 0x00; /* reg addr LSB */
> >>>>>>>>      			memcpy(&buf[5], msg[0].buf, msg[0].len);
> >>>>>>>> 
> >>>>>>>> -			ret = af9035_ctrl_msg(d, &req);
> >>>>>>>> +			if (state->block_read) {
> >>>>>>>> +				msg[1].buf[0] = 0x3f;
> >>>>>>>> +				ret = 0;
> >>>>>>>> +			} else
> >>>>>>>> +				ret = af9035_ctrl_msg(d, &req);
> >>>>>>>> 
> >>>>>>>>      		}
> >>>>>>>>      	
> >>>>>>>>      	} else if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
> >>>>>>>>      	
> >>>>>>>>      		if (msg[0].len > 40) {
> >>>>>>>> 
> >>>>>>>> @@ -638,6 +642,17 @@ static int af9035_read_config(struct dvb
> >>>>>>>> 
> >>>>>>>>      	for (i = 0; i < ARRAY_SIZE(state->af9033_config); i++)
> >>>>>>>>      	
> >>>>>>>>      		state->af9033_config[i].clock = clock_lut[tmp];
> >>>>>>>> 
> >>>>>>>> +	state->block_read = false;
> >>>>>>>> +
> >>>>>>>> +	if (le16_to_cpu(d->udev->descriptor.idVendor) ==
> >>>>>>>> USB_VID_AVERMEDIA
> >>>>>>>> &&
> >>>>>>>> +		le16_to_cpu(d->udev->descriptor.idProduct) ==
> >>>>>>>> +			USB_PID_AVERMEDIA_TWINSTAR) {
> >>>>>>>> +		dev_dbg(&d->udev->dev,
> >>>>>>>> +				"%s: AverMedia Twinstar: block i2c read from tuner\n",
> >>>>>>>> +				__func__);
> >>>>>>>> +		state->block_read = true;
> >>>>>>>> +	}
> >>>>>>>> +
> >>>>>>>> 
> >>>>>>>>      	return 0;
> >>>>>>>>      
> >>>>>>>>      err:
> >>>>>>>> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.h
> >>>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.h ---
> >>>>>>>> linux/drivers/media/usb/dvb-usb-v2/af9035.h	2013-01-07
> >>>>>>>> 05:45:57.000000000 +0100 +++
> >>>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.h	2013-02-08
> >>>>>>>> 22:52:42.293842710 +0100 @@ -54,6 +54,7 @@ struct usb_req {
> >>>>>>>> 
> >>>>>>>>      struct state {
> >>>>>>>>      
> >>>>>>>>      	u8 seq; /* packet sequence number */
> >>>>>>>>      	bool dual_mode;
> >>>>>>>> 
> >>>>>>>> +	bool block_read;
> >>>>>>>> 
> >>>>>>>>      	struct af9033_config af9033_config[2];
> >>>>>>>>      
> >>>>>>>>      };
> >>>>>>> 
> >>>>>>> Could you test if faking tuner ID during attach() is enough?
> >>>>>>> 
> >>>>>>> Also, I would like to know what is returned error code from firmware
> >>>>>>> when it fails. Enable debugs to see it. It should print something
> >>>>>>> like
> >>>>>>> that: af9035_ctrl_msg: command=03 failed fw error=2
> >>>>>>> 
> >>>>>>> 
> >>>>>>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
> >>>>>>> b/drivers/media/usb/dvb-usb-v2/af9035.c
> >>>>>>> index a1e953a..5a4f28d 100644
> >>>>>>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> >>>>>>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> >>>>>>> @@ -1082,9 +1082,22 @@ static int af9035_tuner_attach(struct
> >>>>>>> dvb_usb_adapter *adap)
> >>>>>>> 
> >>>>>>>                             tuner_addr = 0x60 | 0x80; /* I2C bus
> >>>>>>>                             hack
> >>>>>>>                             */
> >>>>>>>                     
> >>>>>>>                     }
> >>>>>>> 
> >>>>>>> +               // fake used tuner for demod firmware / i2c adapter
> >>>>>>> +               if (adap->id == 0)
> >>>>>>> +                       ret = af9035_wr_reg(d, 0x00f641,
> >>>>>>> AF9033_TUNER_FC0011);
> >>>>>>> +               else
> >>>>>>> +                       ret = af9035_wr_reg(d, 0x10f641,
> >>>>>>> AF9033_TUNER_FC0011);
> >>>>>>> +
> >>>>>>> 
> >>>>>>>                     /* attach tuner */
> >>>>>>>                     fe = dvb_attach(mxl5007t_attach, adap->fe[0],
> >>>>>>>                     &d->i2c_adap,
> >>>>>>>                     
> >>>>>>>                                     tuner_addr,
> >>>>>>> 
> >>>>>>> &af9035_mxl5007t_config[adap->id]);
> >>>>>>> +
> >>>>>>> +               // return correct tuner
> >>>>>>> +               if (adap->id == 0)
> >>>>>>> +                       ret = af9035_wr_reg(d, 0x00f641,
> >>>>>>> AF9033_TUNER_MXL5007T);
> >>>>>>> +               else
> >>>>>>> +                       ret = af9035_wr_reg(d, 0x10f641,
> >>>>>>> AF9033_TUNER_MXL5007T);
> >>>>>>> +
> >>>>>>> 
> >>>>>>>                     break;
> >>>>>>>             
> >>>>>>>             case AF9033_TUNER_TDA18218:
> >>>>>>>                     /* attach tuner */
> >>>>>>> 
> >>>>>>> regards
> >>>>>>> Antti
> >>>>>> 
> >>>>>> I will try with fake tuner, but I can't test unil next weekend.
> >>>>>> If I remember, the read operation is performed, and return good
> >>>>>> value,
> >>>>>> but after that, all the i2c transfers fail. Seee:
> >>>>>> 
> >>>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg56346.html
> >>>>>> 
> >>>>>> Jose Alberto
> >>>>> 
> >>>>> I tried with fake tuner without success:
> >>>>> 
> >>>>> [ 1346.707405] DVB: registering new adapter (AVerMedia Twinstar
> >>>>> (A825))
> >>>>> [ 1346.959043] i2c i2c-1: af9033: firmware version: LINK=11.5.9.0
> >>>>> OFDM=5.17.9.1
> >>>>> [ 1346.962920] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech
> >>>>> AF9033 (DVB-T))...
> >>>>> [ 1347.439354] mxl5007t 1-0060: creating new instance
> >>>>> [ 1347.440644] mxl5007t_get_chip_id: unknown rev (3f)
> >>>>> [ 1347.440652] mxl5007t_get_chip_id: MxL5007T detected @ 1-0060
> >>>>> [ 1347.443023] mxl5007t_write_reg: 472: failed!
> >>>>> [ 1347.443031] mxl5007t_attach: error -121 on line 903
> >>>>> [ 1347.443790] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' error
> >>>>> while
> >>>>> loading driver (-19)
> >>>>> [ 1347.446624] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)'
> >>>>> successfully deinitialized and disconnected
> >>>> 
> >>>> I don't see how the hell it could even go to the mxl5007t_write_reg()
> >>>> during attach. Any idea?
> >>> 
> >>> Now with the patches I sent for mxl5007 in the attach function
> >>> mxl5007t_soft_reset is called, and also  loop_thru_enable is writed. The
> >>> problem is that the read is performed and it return a good value, but
> >>> the
> >>> next writes fail.
> >>> 
> >>>> I have some thoughts that mxl5007t do not use repeated condition.
> >>>> Driver
> >>>> still does that. Could you test to perform register read without a
> >>>> repeated I2C condition?
> >>> 
> >>> How I can do that? what it is a repeated i2c condition?
> >> 
> >> You should take a look for I2C specification.
> >> 
> >> Please test that:
> >> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_i
> >> 2c_ mxl5007t_test
> >> 
> >> It fixes similar issue of AF9015 driver :)
> >> 
> >> I am not able to test AF9035 as I have no hw. It is compile tested only.
> >> Try to do some tweaking for AF9035 implementation if it does not work!
> >> 
> >> regards
> >> Antti
> > 
> > I try with the i2c changes of your tree, and don't work, but there are
> > some
> > differences. With the i2c changes now the chip is recognized as
> > MxL5007T.v4
> > and without the changes the chip is recognized as unknown rev (3f). But
> > the
> > problem after the i2c read persit.
> > 
> > [ 1784.774117] DVB: registering new adapter (AVerMedia Twinstar (A825))
> > [ 1784.877636] i2c i2c-4: af9033: firmware version: LINK=11.5.9.0
> > OFDM=5.17.9.1
> > [ 1784.884771] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech
> > AF9033 (DVB-T))...
> > [ 1785.274753] mxl5007t 4-0060: creating new instance
> > [ 1785.276886] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 4-0060
> > [ 1785.279252] mxl5007t_write_reg: 472: failed!
> > [ 1785.279260] mxl5007t_attach: error -121 on line 940
> > [ 1785.279703] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' error
> > while
> > loading driver (-19)
> > [ 1785.282377] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)'
> > successfully deinitialized and disconnected
> 
> I have asked that earlier, but Haven't got answer. Could you say how it
> fails? mxl5007t is a little bit dummy and didn't print any hint why it
> fails - just set error -EREMOTEIO in any case.
> 
> Enable dvb_usb_v2 and dvb_usb_af9035 debugs to see what it returns. I
> want to see those raw debug lines from dvb_usb_v2 + af9035 debugs.
> 
> Also, could you add hw sniffer to I2C bus and look what goes there?
> 
> regards
> Antti

I can't make dynamic debug work, but I put some printks in af9035. The result 
is:

Witout i2c changes:

[ 8433.114216] i2c i2c-1: af9033: firmware version: LINK=11.5.9.0 
OFDM=5.17.9.1
[ 8433.119700] af9035_ctrl_msg: failed1=0
[ 8433.128423] af9035_ctrl_msg: failed1=0
[ 8433.128450] usb 1-2: DVB: registering adapter 1 frontend 0 (Afatech AF9033 
(DVB-T))...
[ 8433.128770] mxl5007t 1-00e0: creating new instance
[ 8433.134945] af9035_ctrl_msg: failed1=0
[ 8433.134962] mxl5007t_get_chip_id: unknown rev (3f)
[ 8433.134970] mxl5007t_get_chip_id: MxL5007T detected @ 1-00e0
[ 8433.141312] af9035_ctrl_msg: command=03 failed fw error=4
[ 8433.141324] af9035_ctrl_msg: failed2=-5
[ 8433.141332] mxl5007t_write_reg: 472: failed!
[ 8433.141340] mxl5007t_attach: error -121 on line 903
[ 8433.141737] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' error while 
loading driver (-19)
[ 8433.144481] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' successfully 
deinitialized and disconnected

With i2c changes:
[ 9300.143397] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech AF9033 
(DVB-T))...
[ 9300.144204] af9035_ctrl_msg: failed1=0
[ 9300.144620] af9035_ctrl_msg: failed1=0
[ 9300.144992] af9035_ctrl_msg: failed1=0
[ 9300.176123] af9035_ctrl_msg: failed1=0
[ 9300.478122] af9035_ctrl_msg: failed1=0
[ 9300.478484] af9035_ctrl_msg: failed1=0
[ 9300.478858] af9035_ctrl_msg: failed1=0
[ 9300.479245] af9035_ctrl_msg: failed1=0
[ 9300.479609] af9035_ctrl_msg: failed1=0
[ 9300.479984] af9035_ctrl_msg: failed1=0
[ 9300.518083] mxl5007t 1-0060: creating new instance
[ 9300.519179] af9035_ctrl_msg: failed1=0
[ 9300.520063] af9035_ctrl_msg: failed1=0
[ 9300.520083] mxl5007t_get_chip_id: MxL5007T.v4 detected @ 1-0060
[ 9300.522498] af9035_ctrl_msg: command=03 failed fw error=4
[ 9300.522505] af9035_ctrl_msg: failed2=-5
[ 9300.522513] mxl5007t_write_reg: 472: failed!
[ 9300.522522] mxl5007t_attach: error -121 on line 940
[ 9300.522907] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' error while 
loading driver (-19)
[ 9300.525680] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' successfully 
deinitialized and disconnected


Note that the read operation is performed without error, the error is in the 
next write operation. ¿Do you need more detailed logs?

Jose Alberto

