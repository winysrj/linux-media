Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout01.posteo.de ([185.67.36.65]:42356 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752855AbdLUM4S (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 07:56:18 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout01.posteo.de (Postfix) with ESMTPS id 4446E20F92
        for <linux-media@vger.kernel.org>; Thu, 21 Dec 2017 13:56:16 +0100 (CET)
Date: Thu, 21 Dec 2017 13:54:44 +0100
From: Kristian Beilke <beilke@posteo.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
        alan@linux.intel.com
Subject: Re: [BUG] atomisp_ov2680 not initializing correctly
Message-ID: <20171221125444.GB2935@ber-nb-001.aisec.fraunhofer.de>
References: <42dfd60f-2534-b9cd-eeab-3110d58ef7c0@posteo.de>
 <20171219120020.w7byb7bv3hhzn2jb@valkosipuli.retiisi.org.uk>
 <1513715821.7000.228.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
        micalg=sha-256; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <1513715821.7000.228.camel@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2017 at 10:37:01PM +0200, Andy Shevchenko wrote:
> On Tue, 2017-12-19 at 14:00 +0200, Sakari Ailus wrote:
> > Cc Alan and Andy.
> >=20
> > On Sat, Dec 16, 2017 at 04:50:04PM +0100, Kristian Beilke wrote:
> > > Dear all,
> > >=20
> > > I am trying to get the cameras in a Lenovo IdeaPad Miix 320 (Atom
> > > x5-Z8350 BayTrail) to work. The front camera is an ov2680. With
> > > kernel
> > > 4.14.4 and 4.15rc3 I see the following dmesg output:
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
> In any case, I have no firmware to test BayTrail hardware I have (MRD7).
>=20
> The driver claims it needs:
>=20
> Firmware file: shisp_2400b0_v21.bin
> Version string: irci_stable_candrpv_0415_20150521_0458
>=20
> What I have is:
>=20
> Version string: irci_stable_candrpv_0415_20150423_1753
> SHA1: 548d26a9b5daedbeb59a46ea1da69757d92cd4d6  shisp_2400b0_v21.bin
>

I am a bit at a loss here. The TODO file says

7. The ISP code depends on the exact FW version. The version defined in
   BYT:
   drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
   static const char *release_version =3D STR(irci_stable_candrpv_0415_2015=
0521_0458);
   CHT:
   drivers/staging/media/atomisp/pci/atomisp2/css/sh_css_firmware.c
   static const char *release_version =3D STR(irci_ecr-master_20150911_0724=
);

The different files obviously have been merged into the first:

/* The string STR is a place holder
 * which will be replaced with the actual RELEASE_VERSION
 * during package generation. Please do not modify  */
#ifndef ISP2401
static const char *release_version =3D STR(irci_stable_candrpv_0415_2015052=
1_0458);
#else
static const char *release_version =3D STR(irci_ecr-master_20150911_0724);
#endif

Trying to find the firmware files I came up with:

strings shisp_2400b0_v21.bin | grep irci
irci_stable_candrpv_0415_20150423_1753

strings shisp_2401a0_v21.bin | grep irci
irci_stable_candrpv_0415_20150521_0458

which seems to be an odd match. The CherryTrail FW is older than the one
expected, but I could not find a newer one. The BayTrail FW is the same
you have (but it should at least be compatible).
Any hints on where to find the expected FW files? As my hardware is
no android device, I can not look into an update kit.

> > > [   21.469907] ov2680: module is from the staging directory, the
> > > quality
> > >  is unknown, you have been warned.
> > > [   21.492774] ov2680 i2c-OVTI2680:00: gmin: initializing atomisp
> > > module
> > > subdev data.PMIC ID 1
> > > [   21.492891] acpi OVTI2680:00: Failed to find gmin variable
> > > OVTI2680:00_CamClk
> > > [   21.492974] acpi OVTI2680:00: Failed to find gmin variable
> > > OVTI2680:00_ClkSrc
> > > [   21.493090] acpi OVTI2680:00: Failed to find gmin variable
> > > OVTI2680:00_CsiPort
> > > [   21.493209] acpi OVTI2680:00: Failed to find gmin variable
> > > OVTI2680:00_CsiLanes
> > > [   21.493511] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V1P8SX
> > > not
> > > found, using dummy regulator
> > > [   21.493550] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V2P8SX
> > > not
> > > found, using dummy regulator
> > > [   21.493569] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply V1P2A
> > > not
> > > found, using dummy regulator
> > > [   21.493585] ov2680 i2c-OVTI2680:00: i2c-OVTI2680:00 supply
> > > VPROG4B
> > > not found, using dummy regulator
> > > [   21.568134] ov2680 i2c-OVTI2680:00: camera pdata: port: 0 lanes:
> > > 1
> > > order: 00000002
> > > [   21.568257] ov2680 i2c-OVTI2680:00: read from offset 0x300a error
> > > -121
> > > [   21.568265] ov2680 i2c-OVTI2680:00: sensor_id_high =3D 0xffff
> > > [   21.568269] ov2680 i2c-OVTI2680:00: ov2680_detect err s_config.
> > > [   21.568291] ov2680 i2c-OVTI2680:00: sensor power-gating failed
> > >=20
> > > Afterwards I do not get a camera device.
> > >=20
> > > Am I missing some firmware or dependency?
>=20
> See above.
>=20
> > >  Can I somehow help to improve
> > > the driver?
>=20
> Yes, definitely, but first of all we need to find at least one device
> and corresponding firmware where it actually works.
>=20
> For me it doesn't generate any interrupt (after huge hacking to make
> that firmware loaded and settings / platform data applied).
>=20

What exactly are you looking for? An Android device where the ov2680
works? Some x86_64 hardware, where the matching firmware is available and
the driver in 4.15 works?

> --=20
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Intel Finland Oy

--GID0FwUMdk1T2AWN
Content-Type: application/x-pkcs7-signature
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIISDAYJKoZIhvcNAQcCoIIR/TCCEfkCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0B
BwGggg8cMIIFDTCCA/WgAwIBAgIKEuOBUwAAAAAAHTANBgkqhkiG9w0BAQUFADCBijELMAkG
A1UEBhMCQ0gxEDAOBgNVBAoTB1dJU2VLZXkxJjAkBgNVBAsTHUNvcHlyaWdodCAoYykgMjAw
NSBXSVNlS2V5IFNBMRYwFAYDVQQLEw1JbnRlcm5hdGlvbmFsMSkwJwYDVQQDEyBXSVNlS2V5
IENlcnRpZnlJRCBTdGFuZGFyZCBHMSBDQTAeFw0xMjAxMjMxNTMyMjBaFw0yMDEyMjMxMDU1
MzJaMIGSMQswCQYDVQQGEwJDSDEQMA4GA1UEChMHV0lTZUtleTEmMCQGA1UECxMdQ29weXJp
Z2h0IChjKSAyMDEyIFdJU2VLZXkgU0ExFjAUBgNVBAsTDUludGVybmF0aW9uYWwxMTAvBgNV
BAMTKFdJU2VLZXkgQ2VydGlmeUlEIFN0YW5kYXJkIFNlcnZpY2VzIENBIDIwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDEwRJCD5mtCZwFwgKi/6mQYZYKdnw6iJd3RRUQYaJ3
BQ13Mw2RW+YAkWn7TjawcRb7wGpC/16KDaEM13d5As61egVZsXb4cgI1xLZI4ok9tlh+SHm6
SX38HCcOKg4YT43xcq1b5pcerhp5/HsI+wovic2WIuA/BVD4Tv0t46EP2avjijQPCcRPYhaG
LC6dtqfSh0/jcutPJJRG9An29KcPfx137bTkFrQnUZTR0SThkixhWpsYiCVFCazKMHlwUDXK
a0m41BI6q01lmDfz1Hfuft5r89ltThCKkTvo//a3gulz43DO9qv5emTHISqZXOi8fRCWa05T
P5Q+AK5RhjTPAgMBAAGjggFpMIIBZTASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBS7
9c6uWyghS9wCtE1Nj7NK4rThkzALBgNVHQ8EBAMCAYYwEAYJKwYBBAGCNxUBBAMCAQAwTgYD
VR0gBEcwRTA7BghghXQFDgQCATAvMC0GCCsGAQUFBwIBFiFodHRwOi8vd3d3Lndpc2VrZXku
Y29tL3JlcG9zaXRvcnkwBgYEVR0gADAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNV
HSMEGDAWgBT62HEyPNzq0jV+X9hk4vH/HGarbTA8BgNVHR8ENTAzMDGgL6AthitodHRwOi8v
cHVibGljLndpc2VrZXkuY29tL2NybC93Y2lkc2cxY2EuY3JsMEcGCCsGAQUFBwEBBDswOTA3
BggrBgEFBQcwAoYraHR0cDovL3B1YmxpYy53aXNla2V5LmNvbS9jcnQvd2NpZHNnMWNhLmNy
dDANBgkqhkiG9w0BAQUFAAOCAQEAe0VgXnBsOf3nvyagCyzGG67gxFooo8QrHSYhA0da9TrP
h0Jln0FkEh4zN5pA+hgL353tBAYDkPhbcCwW+t50n9R8y3VVaaSCqP2NpU+GTfd/D8OM8sGf
7KGFzVh/1Cx2x7whaBZ1w1F/BDX/LEmP4aJX0+2l+XHM7ejbZBv52hqZxHFxY2qTl0bV2Wfa
Dh7UYkqjzkE7HW9vgLD13X5BDaidl1Taa2zjouW/BTuwmD/8WbTSP4KJpblia+2LtzO6VJV/
if7wqXZr4UA0kpTYwKo3zx2WdFVsOLYnt/QsOZS8WsdlNR30V/040wPH+F6XNPnTnlw0UxZz
t/mnWmeUEDCCBQIwggPqoAMCAQICCmENl3QAAAAAAAMwDQYJKoZIhvcNAQEFBQAwgYoxCzAJ
BgNVBAYTAkNIMRAwDgYDVQQKEwdXSVNlS2V5MRswGQYDVQQLExJDb3B5cmlnaHQgKGMpIDIw
MDUxIjAgBgNVBAsTGU9JU1RFIEZvdW5kYXRpb24gRW5kb3JzZWQxKDAmBgNVBAMTH09JU1RF
IFdJU2VLZXkgR2xvYmFsIFJvb3QgR0EgQ0EwHhcNMDUxMjIzMTA0NTMyWhcNMjAxMjIzMTA1
NTMyWjCBijELMAkGA1UEBhMCQ0gxEDAOBgNVBAoTB1dJU2VLZXkxJjAkBgNVBAsTHUNvcHly
aWdodCAoYykgMjAwNSBXSVNlS2V5IFNBMRYwFAYDVQQLEw1JbnRlcm5hdGlvbmFsMSkwJwYD
VQQDEyBXSVNlS2V5IENlcnRpZnlJRCBTdGFuZGFyZCBHMSBDQTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBANpmU2qKrH/Ny/HjgBqEZsXaJDSh4Tv4SopTfsqnd0k8xjvTaIaH
dACLBO4rnBdPUH5UjQh4rVdSI0vesRvrRWZ1zrCwoTcprTqAhNy5UIQUaLoZQfm8ztv2YVk1
T9LgjeEEJ8ZTrZVjYqzwQNTl9fvUmtdot32HRVEbyy9DPzPIDkvTmisUtHu870iBVHY9kYpP
kbRckE+2CPk7Pw894t4GS4KA0Y7dNjDWBXPz0kKaaWKzpRJsoXztoMlMQ6238lFXhxiW/qgw
pPDEL3KraQJlj1Fl4fRFZvjLT1pLlZeyhNLey+xaNT31vGdJ422yLQvCLGD/+Qz6WTZ/m9Iu
B5UCAwEAAaOCAWYwggFiMBIGA1UdEwEB/wQIMAYBAf8CAQEwHQYDVR0OBBYEFPrYcTI83OrS
NX5f2GTi8f8cZqttMAsGA1UdDwQEAwIBhjAQBgkrBgEEAYI3FQEEAwIBADBNBgNVHSAERjBE
MDoGB2CFdAUOBAIwLzAtBggrBgEFBQcCARYhaHR0cDovL3d3dy53aXNla2V5LmNvbS9yZXBv
c2l0b3J5MAYGBFUdIAAwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwHwYDVR0jBBgwFoAU
swN+rja8sHnR3JQmthG+IbJphpQwOwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL3B1YmxpYy53
aXNla2V5LmNvbS9jcmwvb3dncmdhY2EuY3JsMEYGCCsGAQUFBwEBBDowODA2BggrBgEFBQcw
AoYqaHR0cDovL3B1YmxpYy53aXNla2V5LmNvbS9jcnQvb3dncmdhY2EuY3J0MA0GCSqGSIb3
DQEBBQUAA4IBAQBfr3cEG281wQCng9cCTfR4uhhYqFZ99ftyRGPgvyHzKY+1oFMYBQ5/GNcI
CRpmKgVaomyYEiEs1+uNU6CW/3agjM92veh2AnudIaAUe6HwHltvsoMIz/oWd7YGBDzoB0mt
18VlsvPRLIqWyvRQhmvJv/zKnqfc0FmstTdNQS1/P54d9kXPvrSXwmsgwETevIKIh3ngMYDK
luqrEwQiYMhzUM/BaMF258u7kHjkQO9N+VVgNWaxd9LMZFMvhF/1EbsC6ClpGqegk5oy4+zu
0SOJfjhfBll9bak+3Qm2fQUF9cUHFXUzjgtG9r/Kt12qfvuF7GlR+ove4tfYkJmqwkwJMIIF
ATCCA+mgAwIBAgIKdfdTVAAAAABJ8zANBgkqhkiG9w0BAQUFADCBkjELMAkGA1UEBhMCQ0gx
EDAOBgNVBAoTB1dJU2VLZXkxJjAkBgNVBAsTHUNvcHlyaWdodCAoYykgMjAxMiBXSVNlS2V5
IFNBMRYwFAYDVQQLEw1JbnRlcm5hdGlvbmFsMTEwLwYDVQQDEyhXSVNlS2V5IENlcnRpZnlJ
RCBTdGFuZGFyZCBTZXJ2aWNlcyBDQSAyMB4XDTE3MTExODIzMjk0N1oXDTE4MTExODIzMjk0
N1owfzFBMD8GA1UECxM4UGVyc29uJ3MgSWRlbnRpdHkgbm90IFZlcmlmaWVkIC0gQ2VydGlm
eUlEIFN0YW5kYXJkIFVzZXIxGTAXBgNVBAMMEGJlaWxrZUBwb3N0ZW8uZGUxHzAdBgkqhkiG
9w0BCQEWEGJlaWxrZUBwb3N0ZW8uZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
AQCmdkYmQhy440eJt+Kc0nVCEnCxJ1cOR0/p4YINPifUhMrv7G/lqi7jzxfOH8fLgFRls1HY
BNwkSfqMJaAd4IoCxA1PoKFInu45eStoVADjyTkbXMO1vOo5PwYZcYBAljXtNWXOJsJ7V+DC
q4zYdzpxiC8wC3tHhxGR03mp2H1DvSNqY5FbBr20wvka1PIH5cvcz1KTAkEmI1rir2oCt9vE
GDz236dKZIde2+VrEUaHhD67nm3T0zCM562tVs2uIQ28UcwefOUBBzkpR32R7dMevnH45nLE
4zjcB+clT6HU2XhpOYL9Sby8//+8ENhgIx8eakHaRy0tQUwrRsjU3gipAgMBAAGjggFpMIIB
ZTAOBgNVHQ8BAf8EBAMCBLAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1Ud
DgQWBBRaj6mo4t8l4NzccHUfhavLaxNJIjAfBgNVHSMEGDAWgBS79c6uWyghS9wCtE1Nj7NK
4rThkzA8BgNVHR8ENTAzMDGgL6AthitodHRwOi8vcHVibGljLndpc2VrZXkuY29tL2NybC93
Y2lkc3NjYTIuY3JsMEcGCCsGAQUFBwEBBDswOTA3BggrBgEFBQcwAoYraHR0cDovL3B1Ymxp
Yy53aXNla2V5LmNvbS9jcnQvd2NpZHNzY2EyLmNydDAnBgkrBgEEAYI3FQoEGjAYMAoGCCsG
AQUFBwMCMAoGCCsGAQUFBwMEMEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwICAgCAMA4G
CCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQUFAAOCAQEA
cxV3xZwWtMMen6jbu1KHtSKi/d7HEBQJ6Ev2Yyt3aS0SHsDqWx2H4GkDJHzygRHzXchW2fdO
RJ3z6DsL0N/oqzik5VkCMMFeYeYwLgeJap54BF27oHB/H0Hko0j896g4mksWvIjL+LKeex1G
WDO1hLDx8SybnG9ILIync7KB6cjCkutnaCI1cm1MpiztH1cmYTJKCS0SCLOogfX0Afsf8V5s
4LpB/8CdF7R52piRtEUDumAxIh20fF/B5I+ozw1/Kj9RqC7o8h9ayJdUSyFieaDPULISnoje
5Ng/NDieyoCEZKeeP+4KJx+Vc1gT+zFVTYmeT75EV2Mop4LI7NHrtjGCArQwggKwAgEBMIGh
MIGSMQswCQYDVQQGEwJDSDEQMA4GA1UEChMHV0lTZUtleTEmMCQGA1UECxMdQ29weXJpZ2h0
IChjKSAyMDEyIFdJU2VLZXkgU0ExFjAUBgNVBAsTDUludGVybmF0aW9uYWwxMTAvBgNVBAMT
KFdJU2VLZXkgQ2VydGlmeUlEIFN0YW5kYXJkIFNlcnZpY2VzIENBIDICCnX3U1QAAAAASfMw
DQYJYIZIAWUDBAIBBQCggeQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMTcxMjIxMTI1NDQ0WjAvBgkqhkiG9w0BCQQxIgQgUQ/UUP5iBCAelLioERGHYLpW
EovOZa6nCRRGIaoFKVUweQYJKoZIhvcNAQkPMWwwajALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEATwPww9lK
n/8NyQ5N/zvUzoSFavO17R/PfqUkOi24QnRA6ILFv4euPPCB/B9kbzHURB4giUFTwTlQGncp
3400ysNSSm9L3Gh0uFHI1GnjCsJWoEXr5vqrqHtKhH1ZSV7R9qow9EVJhQvOVZJ3H5YT+690
cfJTQhujzFrjWL2r73rs1g+vLxJ97kJytRrxqsiBhLJwhmVZDRwOK9/NwaNo0FDba8RhJPvE
XSylRILaFgWPo3RRo30rXhn8bQNj5hl3KMGb652wPoMvqFOhetXOckQIS/Yo2NwZikYCeo5X
l7yABRVTXYm0l2GfFQOmX9J+o6GcUbFs/stjHp3jByLY7w==

--GID0FwUMdk1T2AWN--
