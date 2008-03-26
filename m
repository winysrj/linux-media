Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bitumen.surfer@gmail.com>) id 1JeKzZ-0006Or-Re
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 03:03:58 +0100
Received: by wf-out-1314.google.com with SMTP id 28so2961912wfa.17
	for <linux-dvb@linuxtv.org>; Tue, 25 Mar 2008 19:03:48 -0700 (PDT)
Message-ID: <47E9AEFF.7030504@gmail.com>
Date: Wed, 26 Mar 2008 13:03:43 +1100
From: John <bitumen.surfer@gmail.com>
MIME-Version: 1.0
To: ptay1685 <ptay1685@Bigpond.net.au>
References: <007201c88ce2$5909c850$6e00a8c0@barny1e59e583e>	<47E6DD2D.9040204@iki.fi>
	<001501c88ee1$f0466470$6e00a8c0@barny1e59e583e>
In-Reply-To: <001501c88ee1$f0466470$6e00a8c0@barny1e59e583e>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] leadtek dtv dongle
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1328678570=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============1328678570==
Content-Type: multipart/alternative;
 boundary="------------010503080603070009050005"

This is a multi-part message in MIME format.
--------------010503080603070009050005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

As I originally posted the quoted email below, I might be able to help you.

firstly: lsusb is located in the usbutils package so you may need to 
install it, or you need to prefix the command with its location
i.e. /sbin/lsusb. Please try this first and post the result back to the 
list. (with the -v option please)

secondly in reference to my patch below.
I never heard anything more from the list about it and I have no reason 
to believe it was ever incorporated as a patch. I suspect this dongle is 
a variant sold only in Australia (where you and I are from obviously) 
and so the demand is relatively small - thus no one else was interested. 
I posted more for people like yourself for whom my fix may help.

The only thing this patch did is add an extra identifier so that the 
dongle was recognized. Now that said, I suspect there is an even more 
recent variant released in the last 2/3 months (right after I bought 
mine :( ) which may have a different identifier again. So the result of 
lsusb is even more important.

Unfortunately I got distracted after I got my dongle recognized and 
haven't made it fully work yet (with MythTv) - but if you are interested 
I might have another go at it.

I also note the large number of dibcom related posts in recent months 
which will have a direct bearing on this dongle. So recent versions of 
the dvb code are essential.

Cheers,
J

ptay1685 wrote:
> How do I tell the usb-id? Tried to do a lsusb -v but the command is 
> unrecognised.
>
> Note that the Leadtek device is not actually recognised by the kernel (shown 
> via dmesg).
>
> The following is from a previous conversation on this mailing list and might 
> give you the info you need:
> _______________________________________________________________________________
>
> Hi,
>
> How do I get a patch incorporated into the dvb kernel section ?
>
> After recently purchasing a LeadTek WinFast DTV Dongle I rapidly
> discovered it was the variant that was not recognized in the kernel
>
> i.e. as previously reported at:
> http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022373.html
> http://www.linuxtv.org/pipermail/linux-dvb/2008-January/023175.html
>
> its device ids are: (lsusb)
> ID 0413:6f01 Leadtek Research, Inc.
>
> Rather than make the changes suggested by previous posters I set about
> making a script and associated kernel patches to automatically do this.
> My motivation was simple: I use a laptop with an ATI graphics card and
> fedora 8. I find the best drivers for this card are currently from Livna
> and are updated monthly (and changes are significant at the moment i.e.
> see the phoronix forum). So I would need to do this repeatedly.
>
> In my patch I add an identifier (USB_PID_WINFAST_DTV_DONGLE_STK7700P_B)
> and modify the table appropriately
>
> When I plug it in I now see in my messages log
> kernel: usb 1-4: new high speed USB device using ehci_hcd and address 9
> kernel: usb 1-4: configuration #1 chosen from 1 choice
> kernel: dib0700: loaded with support for 2 different device-types
> kernel: dvb-usb: found a 'Leadtek Winfast DTV Dongle B (STK7700P based)'
> in cold state, will try to load a firmware
> kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-01.fw'
> kernel: dib0700: firmware started successfully.
> kernel: dvb-usb: found a 'Leadtek Winfast DTV Dongle B (STK7700P based)'
> in warm state.
> kernel: dvb-usb: will pass the complete MPEG2 transport stream to the
> software demuxer.
> kernel: DVB: registering new adapter (Leadtek Winfast DTV Dongle B
> (STK7700P based))
> kernel: DVB: registering frontend 0 (DiBcom 7000PC)...
> kernel: MT2060: successfully identified (IF1 = 1220)
> kernel: dvb-usb: Leadtek Winfast DTV Dongle B (STK7700P based)
> successfully initialized and connected.
> kernel: usbcore: registered new interface driver dvb_usb_dib0700
>
>
> My kernel patch ( other scripts to patch the Fedora 8 src rpm's
> available on request)
> ----------------
> --- a/drivers/media/dvb/dvb-usb/dib0700_devices.c       2008-02-13
> 10:05:13.000000000 +1100
> +++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c       2008-02-13
> 10:22:16.000000000 +1100
> @@ -280,6 +280,7 @@ struct usb_device_id dib0700_usb_id_tabl
>                 { USB_DEVICE(USB_VID_LEADTEK,
> USB_PID_WINFAST_DTV_DONGLE_STK7700P) },
>                 { USB_DEVICE(USB_VID_HAUPPAUGE,
> USB_PID_HAUPPAUGE_NOVA_T_STICK_2) },
>                 { USB_DEVICE(USB_VID_AVERMEDIA,
> USB_PID_AVERMEDIA_VOLAR_2) },
> +               { USB_DEVICE(USB_VID_LEADTEK,
> USB_PID_WINFAST_DTV_DONGLE_STK7700P_B) },
>                 { }             /* Terminating entry */
> };
> MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
> @@ -321,7 +322,7 @@ struct dvb_usb_device_properties dib0700
>                         },
>                 },
>
> -               .num_device_descs = 6,
> +               .num_device_descs = 7,
>                 .devices = {
>                         {   "DiBcom STK7700P reference design",
>                                 { &dib0700_usb_id_table[0],
> &dib0700_usb_id_table[1] },
> @@ -346,6 +347,10 @@ struct dvb_usb_device_properties dib0700
>                         {   "Leadtek Winfast DTV Dongle (STK7700P
> based)",
>                                 { &dib0700_usb_id_table[8], NULL },
>                                 { NULL },
> +                       },
> +                       {   "Leadtek Winfast DTV Dongle B (STK7700P
> based)",
> +                               { &dib0700_usb_id_table[11], NULL },
> +                               { NULL },
>                         }
>                 }
>         }, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-02-13
> 10:05:13.000000000 +1100
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-02-13
> 10:18:00.000000000 +1100
> @@ -148,6 +148,7 @@
> #define USB_PID_WINFAST_DTV_DONGLE_COLD                        0x6025
> #define USB_PID_WINFAST_DTV_DONGLE_WARM                        0x6026
> #define USB_PID_WINFAST_DTV_DONGLE_STK7700P            0x6f00
> +#define USB_PID_WINFAST_DTV_DONGLE_STK7700P_B          0x6f01
> #define USB_PID_GENPIX_8PSK_COLD                       0x0200
> #define USB_PID_GENPIX_8PSK_WARM                       0x0201
> #define USB_PID_SIGMATEK_DVB_110                       0x6610
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> ----- Original Message ----- 
> From: "Antti Palosaari" <crope@iki.fi>
> To: "ptay1685" <ptay1685@Bigpond.net.au>
> Cc: <linux-dvb@linuxtv.org>
> Sent: Monday, March 24, 2008 9:43 AM
> Subject: Re: [linux-dvb] leadtek dtv dongle
>
>
>   
>> ptay1685 wrote:
>>     
>>> Any news about the new version of the dtv dongle? Still does not work
>>> with the latest v4l sources. Anyone know whats happening?
>>>
>>> Many thanks,
>>>
>>> Phil T.
>>>       
>> Can you say what is usb-id of your device? Also lsusb -v could be nice
>> to see.
>>
>> regards
>> Antti
>> -- 
>> http://palosaari.fi/
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb 
>>     
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   


--------------010503080603070009050005
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
As I originally posted the quoted email below, I might be able to help
you.<br>
<br>
firstly: lsusb is located in the usbutils package so you may need to
install it, or you need to prefix the command with its location <br>
i.e. /sbin/lsusb. Please try this first and post the result back to the
list. (with the -v option please)<br>
<br>
secondly in reference to my patch below.<br>
I never heard anything more from the list about it and I have no reason
to believe it was ever incorporated as a patch. I suspect this dongle
is a variant sold only in Australia (where you and I are from
obviously) and so the demand is relatively small - thus no one else was
interested. I posted more for people like yourself for whom my fix may
help. <br>
<br>
The only thing this patch did is add an extra identifier so that the
dongle was recognized. Now that said, I suspect there is an even more
recent variant released in the last 2/3 months (right after I bought
mine :( ) which may have a different identifier again. So the result of
lsusb is even more important.<br>
<br>
Unfortunately I got distracted after I got my dongle recognized and
haven't made it fully work yet (with MythTv) - but if you are
interested I might have another go at it. <br>
<br>
I also note the large number of dibcom related posts in recent months
which will have a direct bearing on this dongle. So recent versions of
the dvb code are essential. <br>
<br>
Cheers,<br>
J<br>
<br>
ptay1685 wrote:
<blockquote cite="mid:001501c88ee1$f0466470$6e00a8c0@barny1e59e583e"
 type="cite">
  <pre wrap="">How do I tell the usb-id? Tried to do a lsusb -v but the command is 
unrecognised.

Note that the Leadtek device is not actually recognised by the kernel (shown 
via dmesg).

The following is from a previous conversation on this mailing list and might 
give you the info you need:
_______________________________________________________________________________

Hi,

How do I get a patch incorporated into the dvb kernel section ?

After recently purchasing a LeadTek WinFast DTV Dongle I rapidly
discovered it was the variant that was not recognized in the kernel

i.e. as previously reported at:
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022373.html">http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022373.html</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/pipermail/linux-dvb/2008-January/023175.html">http://www.linuxtv.org/pipermail/linux-dvb/2008-January/023175.html</a>

its device ids are: (lsusb)
ID 0413:6f01 Leadtek Research, Inc.

Rather than make the changes suggested by previous posters I set about
making a script and associated kernel patches to automatically do this.
My motivation was simple: I use a laptop with an ATI graphics card and
fedora 8. I find the best drivers for this card are currently from Livna
and are updated monthly (and changes are significant at the moment i.e.
see the phoronix forum). So I would need to do this repeatedly.

In my patch I add an identifier (USB_PID_WINFAST_DTV_DONGLE_STK7700P_B)
and modify the table appropriately

When I plug it in I now see in my messages log
kernel: usb 1-4: new high speed USB device using ehci_hcd and address 9
kernel: usb 1-4: configuration #1 chosen from 1 choice
kernel: dib0700: loaded with support for 2 different device-types
kernel: dvb-usb: found a 'Leadtek Winfast DTV Dongle B (STK7700P based)'
in cold state, will try to load a firmware
kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-01.fw'
kernel: dib0700: firmware started successfully.
kernel: dvb-usb: found a 'Leadtek Winfast DTV Dongle B (STK7700P based)'
in warm state.
kernel: dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
kernel: DVB: registering new adapter (Leadtek Winfast DTV Dongle B
(STK7700P based))
kernel: DVB: registering frontend 0 (DiBcom 7000PC)...
kernel: MT2060: successfully identified (IF1 = 1220)
kernel: dvb-usb: Leadtek Winfast DTV Dongle B (STK7700P based)
successfully initialized and connected.
kernel: usbcore: registered new interface driver dvb_usb_dib0700


My kernel patch ( other scripts to patch the Fedora 8 src rpm's
available on request)
----------------
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c       2008-02-13
10:05:13.000000000 +1100
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c       2008-02-13
10:22:16.000000000 +1100
@@ -280,6 +280,7 @@ struct usb_device_id dib0700_usb_id_tabl
                { USB_DEVICE(USB_VID_LEADTEK,
USB_PID_WINFAST_DTV_DONGLE_STK7700P) },
                { USB_DEVICE(USB_VID_HAUPPAUGE,
USB_PID_HAUPPAUGE_NOVA_T_STICK_2) },
                { USB_DEVICE(USB_VID_AVERMEDIA,
USB_PID_AVERMEDIA_VOLAR_2) },
+               { USB_DEVICE(USB_VID_LEADTEK,
USB_PID_WINFAST_DTV_DONGLE_STK7700P_B) },
                { }             /* Terminating entry */
};
MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -321,7 +322,7 @@ struct dvb_usb_device_properties dib0700
                        },
                },

-               .num_device_descs = 6,
+               .num_device_descs = 7,
                .devices = {
                        {   "DiBcom STK7700P reference design",
                                { &amp;dib0700_usb_id_table[0],
&amp;dib0700_usb_id_table[1] },
@@ -346,6 +347,10 @@ struct dvb_usb_device_properties dib0700
                        {   "Leadtek Winfast DTV Dongle (STK7700P
based)",
                                { &amp;dib0700_usb_id_table[8], NULL },
                                { NULL },
+                       },
+                       {   "Leadtek Winfast DTV Dongle B (STK7700P
based)",
+                               { &amp;dib0700_usb_id_table[11], NULL },
+                               { NULL },
                        }
                }
        }, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-02-13
10:05:13.000000000 +1100
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-02-13
10:18:00.000000000 +1100
@@ -148,6 +148,7 @@
#define USB_PID_WINFAST_DTV_DONGLE_COLD                        0x6025
#define USB_PID_WINFAST_DTV_DONGLE_WARM                        0x6026
#define USB_PID_WINFAST_DTV_DONGLE_STK7700P            0x6f00
+#define USB_PID_WINFAST_DTV_DONGLE_STK7700P_B          0x6f01
#define USB_PID_GENPIX_8PSK_COLD                       0x0200
#define USB_PID_GENPIX_8PSK_WARM                       0x0201
#define USB_PID_SIGMATEK_DVB_110                       0x6610



_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>

----- Original Message ----- 
From: "Antti Palosaari" <a class="moz-txt-link-rfc2396E" href="mailto:crope@iki.fi">&lt;crope@iki.fi&gt;</a>
To: "ptay1685" <a class="moz-txt-link-rfc2396E" href="mailto:ptay1685@Bigpond.net.au">&lt;ptay1685@Bigpond.net.au&gt;</a>
Cc: <a class="moz-txt-link-rfc2396E" href="mailto:linux-dvb@linuxtv.org">&lt;linux-dvb@linuxtv.org&gt;</a>
Sent: Monday, March 24, 2008 9:43 AM
Subject: Re: [linux-dvb] leadtek dtv dongle


  </pre>
  <blockquote type="cite">
    <pre wrap="">ptay1685 wrote:
    </pre>
    <blockquote type="cite">
      <pre wrap="">Any news about the new version of the dtv dongle? Still does not work
with the latest v4l sources. Anyone know whats happening?

Many thanks,

Phil T.
      </pre>
    </blockquote>
    <pre wrap="">Can you say what is usb-id of your device? Also lsusb -v could be nice
to see.

regards
Antti
-- 
<a class="moz-txt-link-freetext" href="http://palosaari.fi/">http://palosaari.fi/</a>

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a> 
    </pre>
  </blockquote>
  <pre wrap=""><!---->

_______________________________________________
linux-dvb mailing list
<a class="moz-txt-link-abbreviated" href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a class="moz-txt-link-freetext" href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
  </pre>
</blockquote>
<br>
</body>
</html>

--------------010503080603070009050005--


--===============1328678570==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1328678570==--
