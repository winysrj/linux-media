Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21205 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758238AbcIWI1i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 04:27:38 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: yfw <nh26223@gmail.com>, Bin Liu <b-liu@ti.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: Re: g_webcam Isoch high bandwidth transfer
In-Reply-To: <b73898d0-b5ff-d591-0946-acf127453aba@gmail.com>
References: <20160920170441.GA10705@uda0271908> <871t0d4r72.fsf@linux.intel.com> <20160921132702.GA18578@uda0271908> <87oa3go065.fsf@linux.intel.com> <87lgyknyp7.fsf@linux.intel.com> <87d1jw6yfd.fsf@linux.intel.com> <20160922133327.GA31827@uda0271908> <87a8ezn2av.fsf@linux.intel.com> <20160922201131.GD31827@uda0271908> <87shsr5a3e.fsf@linux.intel.com> <b73898d0-b5ff-d591-0946-acf127453aba@gmail.com>
Date: Fri, 23 Sep 2016 11:27:26 +0300
Message-ID: <87k2e358cx.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

yfw <nh26223@gmail.com> writes:
>>>>>> Here's one that actually compiles, sorry about that.
>>>>>
>>>>> No worries, I was sleeping ;-)
>>>>>
>>>>> I will test it out early next week. Thanks.
>>>>
>>>> meanwhile, how about some instructions on how to test this out myself?
>>>> How are you using g_webcam and what are you running on host side? Got a
>>>> nice list of commands there I can use? I think I can get to bottom of
>>>> this much quicker if I can reproduce it locally ;-)
>>>
>>> On device side:
>>> - first patch g_webcam as in my first email in this thread to enable
>>>   640x480@30fps;
>>> - # modprobe g_webcam streaming_maxpacket=3D3072
>>> - then run uvc-gadget to feed the YUV frames;
>>> 	http://git.ideasonboard.org/uvc-gadget.git
>>
>> as is, g_webcam never enumerates to the host. It's calls to
>> usb_function_active() and usb_function_deactivate() are unbalanced. Do
>> you have any other changes to g_webcam?
> With uvc function gadget driver, user daemon uvc-gadget must be started
> before connect to host. Not sure whether g_webcam has same requirement.

f_uvc.c should be handling that by means for usb_function_deactivate().

I'll try keeping cable disconnected until uvc-gadget is running.

>> Also, uvc-gadget.git doesn't compile, had to modify it a bit:
>>
>> -#include "../drivers/usb/gadget/uvc.h"
>> +#include "../drivers/usb/gadget/function/uvc.h"
>>
>> Also fixed a build warning:
>>
>> @@ -732,6 +732,8 @@ int main(int argc, char *argv[])
>>                 fd_set wfds =3D fds;
>>
>>                 ret =3D select(dev->fd + 1, NULL, &wfds, &efds, NULL);
>> +               if (ret < 0)
>> +                       return ret;
>>                 if (FD_ISSET(dev->fd, &efds))
>>                         uvc_events_process(dev);
>>                 if (FD_ISSET(dev->fd, &wfds))
>>
>> Laurent, have you tested g_webcam recently? What's the magic to get it
>> working?
>>
>> Here's what I get out of dmesg:
>>
>> [   58.568380] usb 1-9: new high-speed USB device number 5 using xhci_hcd
>> [   58.738680] usb 1-9: New USB device found, idVendor=3D1d6b, idProduct=
=3D0102
>> [   58.738683] usb 1-9: New USB device strings: Mfr=3D1, Product=3D2, Se=
rialNumber=3D0
>> [   58.738685] usb 1-9: Product: Webcam gadget
>> [   58.738687] usb 1-9: Manufacturer: Linux Foundation
>> [   58.739133] g_webcam gadget: high-speed config #1: Video
>> [   58.739138] g_webcam gadget: uvc_function_set_alt(0, 0)
>> [   58.739139] g_webcam gadget: reset UVC Control
>> [   58.739149] g_webcam gadget: uvc_function_set_alt(1, 0)
>> [   58.804369] uvcvideo: Found UVC 1.00 device Webcam gadget (1d6b:0102)
>> [   58.804479] g_webcam gadget: uvc_function_set_alt(1, 0)
>> [   64.188459] uvcvideo: UVC non compliance - GET_DEF(PROBE) not support=
ed. Enabling workaround.
> Looks like you connect your usb device to your usb host port on same
> board. Nice.

yeah, that helps.

> The GET_DEF is handled by user daemon uvc-gadget. It may be related.

okay.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX5OduAAoJEMy+uJnhGpkGZSgQAIjRYka1wxYWyE97YsywVcng
UhjRpsbZ3RJPXODrLDzhgsK9dTwJMlBxN9vu35ESsN4WgBLBNrYxolFs7aPqfL/W
oH5qR/BDJT9Cnp8BSwPB1q+kPxt5ccsE1brJsGD8uAWjMY1HJ+55qUbFXsnkZsM9
/eqoDf/C52CLLL+3XliOSUMa/7fk8R19T2+jS7cPj00eRcwOu2WeLlqyF1/Tk38q
WKECssJY8H+WyNqFSBqBRBwg+LydlS6HUmxTIW0Ol9XfXz8fleWQhdMXmfBP4ERj
Ox8jZkIRg4QB2gc0fbk84WDelXrkNK9moM8sRIws8vp/2205McXkhDzgudT7dSCb
iUCR//z46+RBTrN1q4jTaCuqzVoagep5ezHH9AAMkaqdkY79OEmeTsaMQ5SQWpQP
QZDTmJhMg08mtuOE3rVjCvbHnSYOo7zlzTWG2UXTDJPKreMUuEmjw8WILWrB9rcW
WVKOxpzsHOj1mir6KzkFBSxUgIAaeLQhz7UpGTkutcDg1h1OpDxB1y3zf53MnukU
mQJ8AmfzGS1nFB/rsMgrA6Ln+FqiQvRWYdp0eWPKWI01uqUP3C7zahbExslM0IWy
/LX06v1tR7wOxvtI/KV7q4RixFL8wbFHF2LTEFeuRADB6eNeLI0pdpF2iRvXe0tg
uKrU9vojmI+BYDhn0qug
=9Iej
-----END PGP SIGNATURE-----
--=-=-=--
