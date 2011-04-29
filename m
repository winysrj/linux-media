Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37419 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab1D2MD2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 08:03:28 -0400
Received: by gwaa18 with SMTP id a18so1275547gwa.19
        for <linux-media@vger.kernel.org>; Fri, 29 Apr 2011 05:03:27 -0700 (PDT)
Message-ID: <4DBAA909.2090102@gmail.com>
Date: Fri, 29 Apr 2011 09:03:21 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: poma <pomidorabelisima@gmail.com>, linux-media@vger.kernel.org,
	andrew.williams@joratech.com, lindsay.mathieson@gmail.com,
	skandalfo@gmail.com, news004@upsilon.org.uk
Subject: Re: Afatech AF9015 & dual tuner - dual_mode B.R.O.K.E.N.
References: <4D5B5FE2.5000302@gmail.com> <4D5CE929.4050102@gmail.com> <4D5D9D10.2060709@gmail.com>
In-Reply-To: <4D5D9D10.2060709@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Antti,

I'm assuming that you're reviewing this patchset, so, I'll update patchwork status
accordingly.

Mauro

Em 17-02-2011 20:11, poma escreveu:
> poma wrote:
>> poma wrote:
>>> To num_adapters = 2, or num_adapters = 1: that is the question!
>>
>> In dual tuner mode, after a while device become unrensponsive,
>> eventually after S5 aka 'Soft Off' system doesn't even boot!
>> Didn't even mention all sorts of 'mumbo-jumbo' with S3 aka 'Suspend to RAM'.
>> Antti, please consider adding 'dual_mode' parameter back.
>>
>> "dvb_usb_af9015 dual_mode=0"
>>
>> Devices to consider:
>>
>> Not Only TV/LifeView DUAL DVB-T USB LV52T
>> (equivalent to TerraTec Cinergy T Stick Dual RC)
>> Afatech AF9013/AF9015 & 2x MaxLinear MxL5007T
>> http://www.notonlytv.net/p_lv52t.html
>>
>> KWorld USB Dual DVB-T TV Stick (DVB-T 399U)
>> Afatech AF9013/AF9015 & 2x MaxLinear MxL5003S
>> http://www.kworld-global.com/main/prod_in.aspx?mnuid=1248&modid=6&prodid=73
>>
>> DigitalNow TinyTwin DVB-T Receiver
>> Afatech AF9013/AF9015 & 2x MaxLinear MxL5005S
>> http://www.digitalnow.com.au/product_pages/TinyTwin.html
>>
>> http://www.spinics.net/lists/linux-dvb/msg31616.html
>> http://www.spinics.net/lists/linux-dvb/msg31621.html
> 
> This patch restore dvb_usb_af9015 'dual mode' parameter - "disable dual mode by default because it is buggy".
> Enabled mode:
> options dvb_usb_af9015 dual_mode=1
> in modprobe referent file.
> 
> ..
> --- a/linux/drivers/media/dvb/dvb-usb/af9015.c    2011-01-10 16:24:45.000000000 +0100
> +++ b/linux/drivers/media/dvb/dvb-usb/af9015.c    2011-02-17 21:58:42.099040739 +0100
> @@ -40,6 +40,9 @@
>  static int dvb_usb_af9015_remote;
>  module_param_named(remote, dvb_usb_af9015_remote, int, 0644);
>  MODULE_PARM_DESC(remote, "select remote");
> +static int dvb_usb_af9015_dual_mode;
> +module_param_named(dual_mode, dvb_usb_af9015_dual_mode, int, 0644);
> +MODULE_PARM_DESC(dual_mode, "enable dual mode");
>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> 
>  static DEFINE_MUTEX(af9015_usb_mutex);
> @@ -841,6 +844,9 @@
>          goto error;
>      af9015_config.dual_mode = val;
>      deb_info("%s: TS mode:%d\n", __func__, af9015_config.dual_mode);
> +    /* disable dual mode by default because it is buggy */
> +    if (!dvb_usb_af9015_dual_mode)
> +        af9015_config.dual_mode = 0;
> 
>      /* Set adapter0 buffer size according to USB port speed, adapter1 buffer
>         size can be static because it is enabled only USB2.0 */
> ..
> 
> rgds,
> poma
> 

