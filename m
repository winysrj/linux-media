Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout01.posteo.de ([185.67.36.65]:34906 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755934AbdLWAcI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 19:32:08 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout01.posteo.de (Postfix) with ESMTPS id 380D720EA5
        for <linux-media@vger.kernel.org>; Sat, 23 Dec 2017 01:32:06 +0100 (CET)
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        alan@linux.intel.com
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
 <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
 <1513715821.7000.228.camel@linux.intel.com>
 <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
 <1513866211.7000.250.camel@linux.intel.com>
From: Kristian Beilke <beilke@posteo.de>
Message-ID: <6d1a2dc7-1d7b-78f3-9334-ccdedaa66510@posteo.de>
Date: Sat, 23 Dec 2017 01:31:46 +0100
MIME-Version: 1.0
In-Reply-To: <1513866211.7000.250.camel@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020600060507030104030300"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020600060507030104030300
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 12/21/2017 03:23 PM, Andy Shevchenko wrote:
> On Thu, 2017-12-21 at 13:54 +0100, Kristian Beilke wrote:
>> On Tue, Dec 19, 2017 at 10:37:01PM +0200, Andy Shevchenko wrote:
>>> On Tue, 2017-12-19 at 14:00 +0200, Sakari Ailus wrote:
>>>> Cc Alan and Andy.
>>>>
>>>> On Sat, Dec 16, 2017 at 04:50:04PM +0100, Kristian Beilke wrote:
>>>>> Dear all,
>>>>>
>>>>> I am trying to get the cameras in a Lenovo IdeaPad Miix 320
>>>>> (Atom
>>>>> x5-Z8350 BayTrail) to work. The front camera is an ov2680. With

CherryTrail

>>> WRT to the messages below it seems we have no platform data for that
>>> device. It needs to be added.
>>>

I tried to do exactly this. Extracted some values from
acpidump/acpixtract and dmidecode, but unsure I nailed it.

>>>>> Can I somehow help to improve
>>>>> the driver?
>>>
>>> Yes, definitely, but first of all we need to find at least one
>>> device
>>> and corresponding firmware where it actually works.
>>>
>>> For me it doesn't generate any interrupt (after huge hacking to make
>>> that firmware loaded and settings / platform data applied).
>>>
>>
>> What exactly are you looking for?
>=20
> For anything that *somehow* works.
>=20
>>  An Android device where the ov2680
>> works?
>=20
> First of all, I most likely do not have hardware with such sensor.
> Second, I'm using one of the prototype HW based on BayTrail with PCI
> enumerable AtomISP.
>=20
>>  Some x86_64 hardware, where the matching firmware is available and
>> the driver in 4.15 works?
>=20
> Yes, that's what I would like to have before moving forward with any ne=
w
> sensor drivers, clean ups or alike type of changes to the driver.
>=20

After your set of patches I applied the CherryTrail support I found here
https://github.com/croutor/atomisp2401

As a result I get:

[    0.000000] DMI: LENOVO 80XF/LNVNB161216, BIOS 5HCN31WW 09/11/2017
[    2.806685] axp20x-i2c i2c-INT33F4:00: AXP20x variant AXP288 found
[    2.849606] axp20x-i2c i2c-INT33F4:00: AXP20X driver loaded
[   19.593200] media: Linux media interface: v0.10
[   19.627138] Linux video capture interface: v2.00
[   19.652771] atomisp_ov2680: module is from the staging directory, the
quality is unknown, you have been warned.
[   19.676093] ov2680 i2c-OVTI2680:00: gmin: initializing atomisp module
subdev data.PMIC ID 2
[   19.676097] ov2680 i2c-OVTI2680:00: suddev name =3D ov2680 0-0010
[   19.677548] gmin_v1p8_ctrl PMIC_AXP.
[   19.685261] axp_regulator_set success.
[   19.685428] axp_v1p8_on XXOV2680 00000010
[   19.691777] axp_regulator_set success.
[   19.708488] dw_dmac INTL9C60:00: DesignWare DMA Controller, 8 channels=

[   19.752432] ov2680 i2c-OVTI2680:00: unable to set PMC rate 1
[   19.760507] dw_dmac INTL9C60:01: DesignWare DMA Controller, 8 channels=

[   19.789335] ov2680 i2c-OVTI2680:00: camera pdata: port: 0 lanes: 1
order: 00000002
[   19.793616] ov2680 i2c-OVTI2680:00: sensor_revision id =3D 0x2680
[   19.793638] gmin_v1p8_ctrl PMIC_AXP.
[   19.802615] axp_regulator_set success.
[   19.806384] axp_regulator_set success.
[   19.806396] ov2680 i2c-OVTI2680:00: register atomisp i2c module type 1=

[   19.859215] shpchp: Standard Hot Plug PCI Controller Driver version: 0=
=2E4
[   19.906592] atomisp: module is from the staging directory, the
quality is unknown, you have been warned.

[   19.910763] **********************************************************=

[   19.910765] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **=

[   19.910766] **                                                      **=

[   19.910767] ** trace_printk() being used. Allocating extra memory.  **=

[   19.910768] **                                                      **=

[   19.910769] ** This means that this is a DEBUG kernel and it is     **=

[   19.910770] ** unsafe for production use.                           **=

[   19.910771] **                                                      **=

[   19.910772] ** If you see this message and you are not debugging    **=

[   19.910773] ** the kernel, report this immediately to your vendor!  **=

[   19.910774] **                                                      **=

[   19.910775] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **=

[   19.910776] **********************************************************=

[   19.923072] (NULL device *): hwmon_device_register() is deprecated.
Please convert the driver to use hwmon_device_register_with_info().
[   19.923219] (NULL device *): hwmon_device_register() is deprecated.
Please convert the driver to use hwmon_device_register_with_info().
[   19.932909] atomisp-isp2 0000:00:03.0: atomisp: device 000022B8
revision 54
[   19.932917] atomisp-isp2 0000:00:03.0: ISP HPLL frequency base =3D 160=
0 MHz
[   20.133834] axp288_fuel_gauge axp288_fuel_gauge: axp288 not
configured by firmware
[   20.162738] atomisp-isp2 0000:00:03.0: Subdev OVTI2680:00
successfully register
[   20.162750] atomisp-isp2 0000:00:03.0: Entity type for entity ATOM
ISP CSI2-port0 was not initialized!
[   20.162753] atomisp-isp2 0000:00:03.0: Entity type for entity ATOM
ISP CSI2-port1 was not initialized!
[   20.162756] atomisp-isp2 0000:00:03.0: Entity type for entity ATOM
ISP CSI2-port2 was not initialized!
[   20.162759] atomisp-isp2 0000:00:03.0: Entity type for entity
file_input_subdev was not initialized!
[   20.162762] atomisp-isp2 0000:00:03.0: Entity type for entity
tpg_subdev was not initialized!
[   20.162765] atomisp-isp2 0000:00:03.0: Entity type for entity
ATOMISP_SUBDEV_0 was not initialized!
[   20.166183] atomisp-isp2 0000:00:03.0: Entity type for entity
ATOMISP_SUBDEV_1 was not initialized!
[   21.120554] rt5645 i2c-10EC5645:00: i2c-10EC5645:00 supply avdd not
found, using dummy regulator
[   21.120587] rt5645 i2c-10EC5645:00: i2c-10EC5645:00 supply cpvdd not
found, using dummy regulator
[   21.145141] intel_sst_acpi 808622A8:00: LPE base: 0x91400000
size:0x200000
[   21.145146] intel_sst_acpi 808622A8:00: IRAM base: 0x914c0000
[   21.145241] intel_sst_acpi 808622A8:00: DRAM base: 0x91500000
[   21.145250] intel_sst_acpi 808622A8:00: SHIM base: 0x91540000
[   21.145262] intel_sst_acpi 808622A8:00: Mailbox base: 0x91544000
[   21.145269] intel_sst_acpi 808622A8:00: DDR base: 0x20000000
[   21.145403] intel_sst_acpi 808622A8:00: Got drv data max stream 25
[   21.892310] atomisp-isp2 0000:00:03.0: Refused to change power state,
currently in D3
[   21.904537] OVTI2680:00:
               ov2680_s_parm:run_mode :2000
[   21.919743] atomisp-isp2 0000:00:03.0: Refused to change power state,
currently in D3
[   21.930399] OVTI2680:00:
               ov2680_s_parm:run_mode :2000
[   21.956479] atomisp-isp2 0000:00:03.0: Refused to change power state,
currently in D3

I am still not sure the FW gets loaded, and there is still no
/dev/camera, but it looks promising. Am I on the right track here, or am
I wasting my (and your) time?


--------------ms020600060507030104030300
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
DxcNMTcxMjIzMDAzMTQ2WjAvBgkqhkiG9w0BCQQxIgQgYUsbLDD5ZyHbCNxrXtE6VFgGe6/K
WDGjyKEKe1ywCVAwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzAN
BggqhkiG9w0DAgIBKDCBsgYJKwYBBAGCNxAEMYGkMIGhMIGSMQswCQYDVQQGEwJDSDEQMA4G
A1UEChMHV0lTZUtleTEmMCQGA1UECxMdQ29weXJpZ2h0IChjKSAyMDEyIFdJU2VLZXkgU0Ex
FjAUBgNVBAsTDUludGVybmF0aW9uYWwxMTAvBgNVBAMTKFdJU2VLZXkgQ2VydGlmeUlEIFN0
YW5kYXJkIFNlcnZpY2VzIENBIDICCnX3U1QAAAAASfMwgbQGCyqGSIb3DQEJEAILMYGkoIGh
MIGSMQswCQYDVQQGEwJDSDEQMA4GA1UEChMHV0lTZUtleTEmMCQGA1UECxMdQ29weXJpZ2h0
IChjKSAyMDEyIFdJU2VLZXkgU0ExFjAUBgNVBAsTDUludGVybmF0aW9uYWwxMTAvBgNVBAMT
KFdJU2VLZXkgQ2VydGlmeUlEIFN0YW5kYXJkIFNlcnZpY2VzIENBIDICCnX3U1QAAAAASfMw
DQYJKoZIhvcNAQEBBQAEggEAWTPq6IksLz9CS/AoOTlCKdOghB9ipPLD92RjclqbpfCCrWVp
iX6KvMYzhFvrYZbM04BiPxGROk9EOhppPcKyqIOso8cu2UIm3yMmboU2m07RW842wPSOehF/
A/5ICnXR+CoQwJWQdXREl8xR8ZVFN2WhY6/0D22+89b0roZ5DaPf+vKFq5VdPRjZBHx8YIm7
dEfXt0ncTphlpGpn7FLEZKYk4lFEOiRIBTZ6LPT6l7jqisxuX943tu2Jm9JYce5Yeh44/K60
b7efw0QiIYazDGmPQ8UOBoM3A2ATFM/17w7dq4agr2nJwyCt+pNvZH03+efwcjDflR6mTOfx
qNwikwAAAAAAAA==
--------------ms020600060507030104030300--
