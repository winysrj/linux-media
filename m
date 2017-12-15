Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.zih.tu-dresden.de ([141.30.67.74]:48534 "EHLO
        mailout5.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755795AbdLOWqo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 17:46:44 -0500
Subject: Re: [PATCH] pvrusb2: correctly return V4L2_PIX_FMT_MPEG in enum_fmt
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <3c98b33d-c92d-6fd1-ac69-215fa70de1b7@xs4all.nl>
 <2333216.hBMPJUJjxL@optiplex-980-apb-1025>
 <699ab89f-6d99-2651-3173-967a2c4db12e@xs4all.nl>
From: Oleksandr Ostrenko <oleksandr.ostrenko@tu-dresden.de>
Message-ID: <b39c3c40-0168-73ba-5840-7708fc783d68@tu-dresden.de>
Date: Fri, 15 Dec 2017 23:46:41 +0100
MIME-Version: 1.0
In-Reply-To: <699ab89f-6d99-2651-3173-967a2c4db12e@xs4all.nl>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050405010104060404070702"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050405010104060404070702
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Dear Hans,

With your patch applied to kernel 4.14.6 on openSUSE I can get the video =

working, changing channels also works. But I don't have any audio=20
output. Even if I just do:

$ cat /dev/video0 > test.mpg

then when I open test.mpg with vlc there is no sound as if it is muted.
I tried 'v4l2-ctl -c mute=3D0', 'v4l2-ctl --set-audio-input=3D0; v4l2-ctl=
=20
--set-audio-input=3D1' so far but nothing changed. Is there something els=
e=20
I could try to get audio output?

Best,
Oleksandr

BTW, on Mint with kernel 4.13.0 regardless of the patch I get a kernel=20
panic as soon as I plug in the device. Something fishy going on there.

On 14.12.17 10:54, Hans Verkuil wrote:
> On 14/12/17 10:52, Oleksandr Ostrenko wrote:
>> On Thursday, December 14, 2017 12:44:42 AM CET Hans Verkuil wrote:
>>> The pvrusb2 code appears to have a some old workaround code for xawtv=
 that
>>> causes a WARN() due to an unrecognized pixelformat 0 in v4l2_ioctl.c.=

>>>
>>> Since all other MPEG drivers fill this in correctly, it is a safe ass=
umption
>>> that this particular problem no longer exists.
>>>
>>> While I'm at it, clean up the code a bit.
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> ---
>>> I'll try to give this a spin in the morning with xawtv and my ivtv ca=
rd
>>> (that also uses V4L2_PIX_FMT_MPEG), just to make sure xawtv no longer=

>>> breaks if it sees it.
>>>
>>> Oleksandr, are you able to test this as well on your pvrusb2?
>>
>> Thanks, Hans, this fixes the original issue on Linux Mint with kernel
>> 4.8.17. Haven't tried it on openSUSE yet. Still, in xawtv I get no TV
>> reception but just a black screen and error messages like:
>>
>> no way to get: 128x96 32 bit TrueColor (LE: bgr-)
>> no way to get: 128x96 32 bit TrueColor (LE: bgr-)
>> no way to get: 128x96 32 bit TrueColor (LE: bgr-)
>> no way to get: 128x96 32 bit TrueColor (LE: bgr-)
>> no way to get: 384x288 32 bit TrueColor (LE: bgr-)
>>
>> Is this another bug?
>=20
> No. xawtv simply doesn't support MPEG formats. So this is what I would =
expect.
>=20
> Regards,
>=20
> 	Hans
>=20
>>
>> Best,
>> Oleksandr
>>
>>>
>>> Regards,
>>>
>>> 	Hans
>>> ---
>>> diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
>>> b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c index 4320bda9352d..cc90be=
364a30
>>> 100644
>>> --- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
>>> +++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
>>> @@ -78,18 +78,6 @@ static int vbi_nr[PVR_NUM] =3D {[0 ... PVR_NUM-1] =
=3D -1};
>>>   module_param_array(vbi_nr, int, NULL, 0444);
>>>   MODULE_PARM_DESC(vbi_nr, "Offset for device's vbi dev minor");
>>>
>>> -static struct v4l2_fmtdesc pvr_fmtdesc [] =3D {
>>> -	{
>>> -		.index          =3D 0,
>>> -		.type           =3D V4L2_BUF_TYPE_VIDEO_CAPTURE,
>>> -		.flags          =3D V4L2_FMT_FLAG_COMPRESSED,
>>> -		.description    =3D "MPEG1/2",
>>> -		// This should really be V4L2_PIX_FMT_MPEG, but xawtv
>>> -		// breaks when I do that.
>>> -		.pixelformat    =3D 0, // V4L2_PIX_FMT_MPEG,
>>> -	}
>>> -};
>>> -
>>>   #define PVR_FORMAT_PIX  0
>>>   #define PVR_FORMAT_VBI  1
>>>
>>> @@ -99,17 +87,11 @@ static struct v4l2_format pvr_format [] =3D {
>>>   		.fmt    =3D {
>>>   			.pix        =3D {
>>>   				.width          =3D 720,
>>> -				.height             =3D 576,
>>> -				// This should really be V4L2_PIX_FMT_MPEG,
>>> -				// but xawtv breaks when I do that.
>>> -				.pixelformat    =3D 0, // V4L2_PIX_FMT_MPEG,
>>> +				.height         =3D 576,
>>> +				.pixelformat    =3D V4L2_PIX_FMT_MPEG,
>>>   				.field          =3D V4L2_FIELD_INTERLACED,
>>> -				.bytesperline   =3D 0,  // doesn't make sense
>>> -						      // here
>>> -				//FIXME : Don't know what to put here...
>>> -				.sizeimage          =3D (32*1024),
>>> -				.colorspace     =3D 0, // doesn't make sense here
>>> -				.priv           =3D 0
>>> +				/* FIXME : Don't know what to put here... */
>>> +				.sizeimage      =3D 32 * 1024,
>>>   			}
>>>   		}
>>>   	},
>>> @@ -407,11 +389,11 @@ static int pvr2_g_frequency(struct file *file, =
void
>>> *priv, struct v4l2_frequency
>>>
>>>   static int pvr2_enum_fmt_vid_cap(struct file *file, void *priv, str=
uct
>>> v4l2_fmtdesc *fd) {
>>> -	/* Only one format is supported : mpeg.*/
>>> -	if (fd->index !=3D 0)
>>> +	/* Only one format is supported: MPEG. */
>>> +	if (fd->index)
>>>   		return -EINVAL;
>>>
>>> -	memcpy(fd, pvr_fmtdesc, sizeof(struct v4l2_fmtdesc));
>>> +	fd->pixelformat =3D V4L2_PIX_FMT_MPEG;
>>>   	return 0;
>>>   }
>>
>>
>=20


--------------ms050405010104060404070702
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
q3Oj40HF2ZbycPTTEkAbnbFBLA3gdH6q2PQJycy2PjXNe/q6XYTuW1G5uo0zeycCAwEAAaOC
Af4wggH6MBIGA1UdEwEB/wQIMAYBAf8CAQEwDgYDVR0PAQH/BAQDAgEGMBEGA1UdIAQKMAgw
BgYEVR0gADAdBgNVHQ4EFgQUxStTkxeDyfVGQu1Dat+2gKZH8uAwHwYDVR0jBBgwFoAUSbfG
z+g9H3/qRHsTKffxCnA+3mQwHAYDVR0RBBUwE4ERcGtpQHR1LWRyZXNkZW4uZGUwgYgGA1Ud
HwSBgDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1
Yi9jcmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1y
b290LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIHXBggrBgEFBQcBAQSByjCBxzAzBggrBgEFBQcw
AYYnaHR0cDovL29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEcGCCsGAQUFBzAC
hjtodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jYWNlcnQvY2Fj
ZXJ0LmNydDBHBggrBgEFBQcwAoY7aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBAImEwEPg6Hg9
eFHAQKtaCiYMOcQsMMWHgU3V7aDSBhsouD+QDSDDpEoiaHgaFNEBsQ3FbYzL60dooWO3BB0F
pqeKWTgM3nzWOrGOjfuM8TAOY03NPxTiyyLCaQwPZtYza9NxzuUOPaDvD6xHMgnzOLUC0JXj
dslPzEFWPQ9CkW6phW9jOAyr4o20afhjKIEAzINjUTM8SC06i83uypdveMYNrvWCp0dYgp/2
it8NYJn9jx35j6tKq0EAePR+cDOOciC0m9QiJ/4B/H/hG/HLQwePerq4eE8Vxn1AE+b6/Ffa
dZcQyUlx/UD8iB1qHmFSmSYBAhRQmyjxBsTiBcFL8E8wggXMMIIEtKADAgECAgwcoFu5gNqs
V1sjNq4wDQYJKoZIhvcNAQELBQAwgYUxCzAJBgNVBAYTAkRFMSgwJgYDVQQKEx9UZWNobmlz
Y2hlIFVuaXZlcnNpdGFldCBEcmVzZGVuMQwwCgYDVQQLEwNaSUgxHDAaBgNVBAMTE1RVIERy
ZXNkZW4gQ0EgLSBHMDIxIDAeBgkqhkiG9w0BCQEWEXBraUB0dS1kcmVzZGVuLmRlMB4XDTE3
MDExOTE1NDEyOVoXDTE5MDcwOTIzNTkwMFowZzELMAkGA1UEBhMCREUxKDAmBgNVBAoMH1Rl
Y2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xETAPBgNVBAsMCElNQywgWklIMRswGQYD
VQQDDBJPbGVrc2FuZHIgT3N0cmVua28wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQC67X5mkD1X1PEnkC7OsqRcIz1ze+tnPix1bWtoaKIv6Fo4qhK/0Nb2kdaN8JyzWKCrfm12
97J/8Irbvt6mzWa4T+pDhc/JT5o/RvlxCy8pw2uSul7O3zi04H9jLVxRgjFjw9TSOjwrgYTS
XUCTPZkRDWjxr4kVd2nQoxIb+wq8O/tPTTKWbLSx4LIrjraJI1dcU179YrcanBtB+WMvlyDG
ibHpylQ7mu2IcVjVHmku5Qh33KdQU5r8yacC2Omx/B8lQVQjlPmLRgFITpqsHHF8FtlhVLJq
rjwhIrmtuCRxCKm3Ip6FS4X0k2SjXJ9HwRLaEODMCDQqXVE0zjSiBAKVAgMBAAGjggJXMIIC
UzBABgNVHSAEOTA3MBEGDysGAQQBga0hgiwBAQQDBTARBg8rBgEEAYGtIYIsAgEEAwEwDwYN
KwYBBAGBrSGCLAEBBDAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggr
BgEFBQcDAgYIKwYBBQUHAwQwHQYDVR0OBBYEFLoxHfuufLcgCk/TT07kIFsUvfXdMB8GA1Ud
IwQYMBaAFMUrU5MXg8n1RkLtQ2rftoCmR/LgMCsGA1UdEQQkMCKBIG9sZWtzYW5kci5vc3Ry
ZW5rb0B0dS1kcmVzZGVuLmRlMIGLBgNVHR8EgYMwgYAwPqA8oDqGOGh0dHA6Ly9jZHAxLnBj
YS5kZm4uZGUvdHUtZHJlc2Rlbi1jYS9wdWIvY3JsL2dfY2FjcmwuY3JsMD6gPKA6hjhodHRw
Oi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2EvcHViL2NybC9nX2NhY3JsLmNybDCB
2QYIKwYBBQUHAQEEgcwwgckwMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUv
T0NTUC1TZXJ2ZXIvT0NTUDBIBggrBgEFBQcwAoY8aHR0cDovL2NkcDEucGNhLmRmbi5kZS90
dS1kcmVzZGVuLWNhL3B1Yi9jYWNlcnQvZ19jYWNlcnQuY3J0MEgGCCsGAQUFBzAChjxodHRw
Oi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2EvcHViL2NhY2VydC9nX2NhY2VydC5j
cnQwDQYJKoZIhvcNAQELBQADggEBAKJbgBIa5I+mUCOsmPUWTmjYw3eX22a1FRhr/bbeg6/p
UtcOwOb0XL4y1PAxL7yl2VYAQcB6RXNRUNc+rhUP5oNRDk/9+ZGp9l0/8uycopXzAA7tR/Ox
zxIOEPJI8QITETmiZit0GLaIuDACbij7gxVR+UKZ3izqOh/rl1YTuOt6cRP12qqNzRXTO/c2
tqZ+bu72k05QrKUMh3M0/7njRTg15FnTdWRyYEm5uNGUaDa45+JWmcV9BkwrOlDwORg0OhMS
n7q96y+PA9GR2/n5FwgZTzS99CIdUnOHED+Th8O3GQOaMG4m+SljkYvWl6q6yYcpemRHvLQN
Q79CmxIg0woxggPzMIID7wIBATCBljCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2hu
aXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUg
RHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUCDByg
W7mA2qxXWyM2rjANBglghkgBZQMEAgEFAKCCAi0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMTcxMjE1MjI0NjQxWjAvBgkqhkiG9w0BCQQxIgQg07a1fuA9
PdETvZDyDmQ7TvHTHp+1D+iTKFOPTh5EsPswbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQME
ASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0D
AgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBpwYJKwYBBAGCNxAEMYGZMIGWMIGFMQsw
CQYDVQQGEwJERTEoMCYGA1UEChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEM
MAoGA1UECxMDWklIMRwwGgYDVQQDExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJKoZIhvcN
AQkBFhFwa2lAdHUtZHJlc2Rlbi5kZQIMHKBbuYDarFdbIzauMIGpBgsqhkiG9w0BCRACCzGB
maCBljCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0
IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEg
MB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUCDBygW7mA2qxXWyM2rjANBgkqhkiG
9w0BAQEFAASCAQAXBoGQdPz2vvnmdYi4M4h0l01ZjyFxOZ83xlU3UKgkYJ3qOWfHbbVeeaCE
tsIIt8IzSKAyEJlWUEocnpL85YKhU+2WvXa9TsFmGXjeThLzR+6GXA0l1UX4JSjkfecPg6n2
syq0XjrmJwXJujAWlhXg9tYkyjPC0dmaAlui+SJx0R0TvWv4u9GVKLl6ZrevMnSF5FAfB4Si
2XzC8vEwQGpe1jLzyGNoYjw+19S/wE74eBcMOX+1oFOB2D/aSYyeFHARiO6rFQe2Gv4rHstV
chBIL5jvgsrnTVR2phCwnjZMItRzrERtnPMFvPfKqUYORir7xOahjCdc42Cx1pheXVqOAAAA
AAAA
--------------ms050405010104060404070702--
