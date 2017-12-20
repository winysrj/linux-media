Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout01.posteo.de ([185.67.36.65]:33080 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752304AbdLTHNI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 02:13:08 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout01.posteo.de (Postfix) with ESMTPS id 74F0D20EC9
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 08:13:06 +0100 (CET)
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, alan@linux.intel.com
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
 <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
 <1513715821.7000.228.camel@linux.intel.com>
From: Kristian Beilke <beilke@posteo.de>
Message-ID: <5d32a9f2-43f9-60d8-0dab-867507156da5@posteo.de>
Date: Wed, 20 Dec 2017 08:13:03 +0100
MIME-Version: 1.0
In-Reply-To: <1513715821.7000.228.camel@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060104090600070706020400"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060104090600070706020400
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/19/2017 09:37 PM, Andy Shevchenko wrote:
> On Tue, 2017-12-19 at 14:00 +0200, Sakari Ailus wrote:
>> Cc Alan and Andy.
>>
>> On Sat, Dec 16, 2017 at 04:50:04PM +0100, Kristian Beilke wrote:
>>> Dear all,
>>>
>>> I am trying to get the cameras in a Lenovo IdeaPad Miix 320 (Atom
>>> x5-Z8350 BayTrail) to work. The front camera is an ov2680. With
>>> kernel
>>> 4.14.4 and 4.15rc3 I see the following dmesg output:
>=20
> It seems I forgot to send the rest of the patches I did while ago
> against AtomISP code.
>=20
> It includes switch to normal DMI matching instead of the crap we have
> there right now.
>=20
> WRT to the messages below it seems we have no platform data for that
> device. It needs to be added.
>=20
> In any case, I have no firmware to test BayTrail hardware I have (MRD7)=
=2E

My mistake here, meant to write CherryTrail, but that probably does not
make a difference for the next steps.

> The driver claims it needs:
>=20
> Firmware file: shisp_2400b0_v21.bin
> Version string: irci_stable_candrpv_0415_20150521_0458
>=20
> What I have is:
>=20
> Version string: irci_stable_candrpv_0415_20150423_1753
> SHA1: 548d26a9b5daedbeb59a46ea1da69757d92cd4d6  shisp_2400b0_v21.bin

=46rom what I read here:
https://www.spinics.net/lists/linux-media/msg116382.html
They are supposedly compatible.

For CherryTrail I need shisp_2401a0_v21.bin it seems.

>>> [   21.469907] ov2680: module is from the staging directory, the
>>> quality
>>>  is unknown, you have been warned.
>>> [   21.492774] ov2680 i2c-OVTI2680:00: gmin: initializing atomisp
>>> module
>>> subdev data.PMIC ID 1
>>> [   21.492891] acpi OVTI2680:00: Failed to find gmin variable
>>> OVTI2680:00_CamClk
>>> [   21.492974] acpi OVTI2680:00: Failed to find gmin variable
>>> OVTI2680:00_ClkSrc
>>> [   21.493090] acpi OVTI2680:00: Failed to find gmin variable
>>> OVTI2680:00_CsiPort
>>> [   21.493209] acpi OVTI2680:00: Failed to find gmin variable
>>> OVTI2680:00_CsiLanes
>>> [   21.493511] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V1P8SX
>>> not
>>> found, using dummy regulator
>>> [   21.493550] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V2P8SX
>>> not
>>> found, using dummy regulator
>>> [   21.493569] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V1P2A
>>> not
>>> found, using dummy regulator
>>> [   21.493585] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply
>>> VPROG4B
>>> not found, using dummy regulator
>>> [   21.568134] ov2680 i2c-OVTI2680:00: camera pdata: port: 0 lanes:
>>> 1
>>> order: 00000002
>>> [   21.568257] ov2680 i2c-OVTI2680:00: read from offset 0x300a error
>>> -121
>>> [   21.568265] ov2680 i2c-OVTI2680:00: sensor_id_high =3D 0xffff
>>> [   21.568269] ov2680 i2c-OVTI2680:00: ov2680_detect err s_config.
>>> [   21.568291] ov2680 i2c-OVTI2680:00: sensor power-gating failed
>>>
>>> Afterwards I do not get a camera device.
>>>
>>> Am I missing some firmware or dependency?
>=20
> See above.
>=20
>>>  Can I somehow help to improve
>>> the driver?
>=20
> Yes, definitely, but first of all we need to find at least one device
> and corresponding firmware where it actually works.
>=20
> For me it doesn't generate any interrupt (after huge hacking to make
> that firmware loaded and settings / platform data applied).

I guess I will apply your patches, add the firmware and see what happens.=

Finding one device and firmware where it works? What do you have in
mind? Android?


--------------ms060104090600070706020400
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
1OX1+9Sa12i3fYdFURvLL0M/M8gOS9OaKxS0e7zvSIFUdj2Rik+RtFyQT7YI+Ts/Dz3i3gZL
goDRjt02MNYFc/PSQpppYrOlEmyhfO2gyUxDrbfyUVeHGJb+qDCk8MQvcqtpAmWPUWXh9EVm
+MtPWkuVl7KE0t7L7Fo1PfW8Z0njbbItC8IsYP/5DPpZNn+b0i4HlQIDAQABo4IBZjCCAWIw
EgYDVR0TAQH/BAgwBgEB/wIBATAdBgNVHQ4EFgQU+thxMjzc6tI1fl/YZOLx/xxmq20wCwYD
VR0PBAQDAgGGMBAGCSsGAQQBgjcVAQQDAgEAME0GA1UdIARGMEQwOgYHYIV0BQ4EAjAvMC0G
CCsGAQUFBwIBFiFodHRwOi8vd3d3Lndpc2VrZXkuY29tL3JlcG9zaXRvcnkwBgYEVR0gADAZ
BgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBSzA36uNrywedHclCa2Eb4h
smmGlDA7BgNVHR8ENDAyMDCgLqAshipodHRwOi8vcHVibGljLndpc2VrZXkuY29tL2NybC9v
d2dyZ2FjYS5jcmwwRgYIKwYBBQUHAQEEOjA4MDYGCCsGAQUFBzAChipodHRwOi8vcHVibGlj
Lndpc2VrZXkuY29tL2NydC9vd2dyZ2FjYS5jcnQwDQYJKoZIhvcNAQEFBQADggEBAF+vdwQb
bzXBAKeD1wJN9Hi6GFioVn31+3JEY+C/IfMpj7WgUxgFDn8Y1wgJGmYqBVqibJgSISzX641T
oJb/dqCMz3a96HYCe50hoBR7ofAeW2+ygwjP+hZ3tgYEPOgHSa3XxWWy89EsipbK9FCGa8m/
/Mqep9zQWay1N01BLX8/nh32Rc++tJfCayDARN68goiHeeAxgMqW6qsTBCJgyHNQz8FowXbn
y7uQeORA7035VWA1ZrF30sxkUy+EX/URuwLoKWkap6CTmjLj7O7RI4l+OF8GWX1tqT7dCbZ9
BQX1xQcVdTOOC0b2v8q3Xap++4XsaVH6i97i19iQmarCTAkwggUNMIID9aADAgECAgoS44FT
AAAAAAAdMA0GCSqGSIb3DQEBBQUAMIGKMQswCQYDVQQGEwJDSDEQMA4GA1UEChMHV0lTZUtl
eTEmMCQGA1UECxMdQ29weXJpZ2h0IChjKSAyMDA1IFdJU2VLZXkgU0ExFjAUBgNVBAsTDUlu
dGVybmF0aW9uYWwxKTAnBgNVBAMTIFdJU2VLZXkgQ2VydGlmeUlEIFN0YW5kYXJkIEcxIENB
MB4XDTEyMDEyMzE1MzIyMFoXDTIwMTIyMzEwNTUzMlowgZIxCzAJBgNVBAYTAkNIMRAwDgYD
VQQKEwdXSVNlS2V5MSYwJAYDVQQLEx1Db3B5cmlnaHQgKGMpIDIwMTIgV0lTZUtleSBTQTEW
MBQGA1UECxMNSW50ZXJuYXRpb25hbDExMC8GA1UEAxMoV0lTZUtleSBDZXJ0aWZ5SUQgU3Rh
bmRhcmQgU2VydmljZXMgQ0EgMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMTB
EkIPma0JnAXCAqL/qZBhlgp2fDqIl3dFFRBhoncFDXczDZFb5gCRaftONrBxFvvAakL/XooN
oQzXd3kCzrV6BVmxdvhyAjXEtkjiiT22WH5IebpJffwcJw4qDhhPjfFyrVvmlx6uGnn8ewj7
Ci+JzZYi4D8FUPhO/S3joQ/Zq+OKNA8JxE9iFoYsLp22p9KHT+Ny608klEb0Cfb0pw9/HXft
tOQWtCdRlNHRJOGSLGFamxiIJUUJrMoweXBQNcprSbjUEjqrTWWYN/PUd+5+3mvz2W1OEIqR
O+j/9reC6XPjcM72q/l6ZMchKplc6Lx9EJZrTlM/lD4ArlGGNM8CAwEAAaOCAWkwggFlMBIG
A1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFLv1zq5bKCFL3AK0TU2Ps0ritOGTMAsGA1Ud
DwQEAwIBhjAQBgkrBgEEAYI3FQEEAwIBADBOBgNVHSAERzBFMDsGCGCFdAUOBAIBMC8wLQYI
KwYBBQUHAgEWIWh0dHA6Ly93d3cud2lzZWtleS5jb20vcmVwb3NpdG9yeTAGBgRVHSAAMBkG
CSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMB8GA1UdIwQYMBaAFPrYcTI83OrSNX5f2GTi8f8c
ZqttMDwGA1UdHwQ1MDMwMaAvoC2GK2h0dHA6Ly9wdWJsaWMud2lzZWtleS5jb20vY3JsL3dj
aWRzZzFjYS5jcmwwRwYIKwYBBQUHAQEEOzA5MDcGCCsGAQUFBzAChitodHRwOi8vcHVibGlj
Lndpc2VrZXkuY29tL2NydC93Y2lkc2cxY2EuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQB7RWBe
cGw5/ee/JqALLMYbruDEWiijxCsdJiEDR1r1Os+HQmWfQWQSHjM3mkD6GAvfne0EBgOQ+Ftw
LBb63nSf1HzLdVVppIKo/Y2lT4ZN938Pw4zywZ/soYXNWH/ULHbHvCFoFnXDUX8ENf8sSY/h
olfT7aX5cczt6NtkG/naGpnEcXFjapOXRtXZZ9oOHtRiSqPOQTsdb2+AsPXdfkENqJ2XVNpr
bOOi5b8FO7CYP/xZtNI/gomluWJr7Yu3M7pUlX+J/vCpdmvhQDSSlNjAqjfPHZZ0VWw4tie3
9Cw5lLxax2U1HfRX/TjTA8f4Xpc0+dOeXDRTFnO3+adaZ5QQMYIEFDCCBBACAQEwgaEwgZIx
CzAJBgNVBAYTAkNIMRAwDgYDVQQKEwdXSVNlS2V5MSYwJAYDVQQLEx1Db3B5cmlnaHQgKGMp
IDIwMTIgV0lTZUtleSBTQTEWMBQGA1UECxMNSW50ZXJuYXRpb25hbDExMC8GA1UEAxMoV0lT
ZUtleSBDZXJ0aWZ5SUQgU3RhbmRhcmQgU2VydmljZXMgQ0EgMgIKdfdTVAAAAABJ8zANBglg
hkgBZQMEAgEFAKCCAkMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMTcxMjIwMDcxMzAzWjAvBgkqhkiG9w0BCQQxIgQg7fwikEOVXRms5LgEV4LqwbLliLWa
4H9KQD2blUBzzOEwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzAN
BggqhkiG9w0DAgIBKDCBsgYJKwYBBAGCNxAEMYGkMIGhMIGSMQswCQYDVQQGEwJDSDEQMA4G
A1UEChMHV0lTZUtleTEmMCQGA1UECxMdQ29weXJpZ2h0IChjKSAyMDEyIFdJU2VLZXkgU0Ex
FjAUBgNVBAsTDUludGVybmF0aW9uYWwxMTAvBgNVBAMTKFdJU2VLZXkgQ2VydGlmeUlEIFN0
YW5kYXJkIFNlcnZpY2VzIENBIDICCnX3U1QAAAAASfMwgbQGCyqGSIb3DQEJEAILMYGkoIGh
MIGSMQswCQYDVQQGEwJDSDEQMA4GA1UEChMHV0lTZUtleTEmMCQGA1UECxMdQ29weXJpZ2h0
IChjKSAyMDEyIFdJU2VLZXkgU0ExFjAUBgNVBAsTDUludGVybmF0aW9uYWwxMTAvBgNVBAMT
KFdJU2VLZXkgQ2VydGlmeUlEIFN0YW5kYXJkIFNlcnZpY2VzIENBIDICCnX3U1QAAAAASfMw
DQYJKoZIhvcNAQEBBQAEggEAhlpYipbHfme1165gRsu4UdB46uvGBQvvFQrV/Ig75towc53g
EA0wtbGhQwvlb1nSiKwEgxftynfB4MRD5pI6KKj0FmDqtDvOq6d2tjE2/A2Rj942HyqncPAJ
qL+LAyWAWqiPpzNpGxkOkhQHlTx9zx1WweGXSgRW4nfExslKbeytd4DLlPB1iLI5Zq/fIfzA
u/UQF5w6VhCloNkuUBfSaaRkgOiwARUEIu/kFSbsZ5Hx6GWqyrIfH0htBVnKXZDD7Y9K1hQn
qgEaj5nF25+e4jBf1GGutR9+CpICoPCVDzraY1s5e/ZNOZQ4WyQEXBfWLae2HnH8qPP1zGgb
cZj7wQAAAAAAAA==
--------------ms060104090600070706020400--
