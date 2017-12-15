Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout6.zih.tu-dresden.de ([141.30.67.75]:45982 "EHLO
        mailout6.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755848AbdLOXC7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 18:02:59 -0500
Received: from mail.zih.tu-dresden.de ([141.76.14.4])
        by mailout6.zih.tu-dresden.de with esmtps (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.84_2)
        (envelope-from <oleksandr.ostrenko@tu-dresden.de>)
        id 1ePz0L-0003KF-6h
        for linux-media@vger.kernel.org; Sat, 16 Dec 2017 00:02:57 +0100
Received: from x55b5fe36.dyn.telefonica.de ([85.181.254.54] helo=[192.168.178.3])
        by server-40.mailclusterdns.zih.tu-dresden.de with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (envelope-from <oleksandr.ostrenko@tu-dresden.de>)
        id 1ePz0L-0003VE-2K
        for linux-media@vger.kernel.org; Sat, 16 Dec 2017 00:02:57 +0100
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Oleksandr Ostrenko <oleksandr.ostrenko@tu-dresden.de>
Subject: [BUG] NULL pointer dereference in pvr2_v4l2_internal_check
Message-ID: <3d81fa8c-8ce9-cc9b-7058-32415b2e39b0@tu-dresden.de>
Date: Sat, 16 Dec 2017 00:02:56 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070602020900060600030204"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070602020900060600030204
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Dear all,

Unplugging the TV tuner (WinTV HVR-1900) from USB port causes a NULL=20
pointer dereference in pvr2_v4l2_internal_check:

[ 2128.129776] usb 1-1: USB disconnect, device number 6
[ 2128.129987] pvrusb2: Device being rendered inoperable
[ 2128.130055] BUG: unable to handle kernel NULL pointer dereference at=20
0000000000000360
[ 2128.130082] IP: pvr2_v4l2_internal_check+0x41/0x60 [pvrusb2]
[ 2128.130085] PGD 0 P4D 0
[ 2128.130092] Oops: 0000 [#1] PREEMPT SMP
[ 2128.130097] Modules linked in: tda10048 tda18271 tda8290 tuner=20
lirc_zilog(C) lirc_dev cx25840 rc_core pvrusb2(O) tveeprom cx2341x=20
dvb_core v4l2_common rfcomm af_packet 8021q garp mrp stp llc nf_log_ipv6 =

xt_comment nf_log_ipv4 nf_log_common xt_LOG xt_limit ip6t_REJECT=20
nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT=20
nf_reject_ipv4 xt_pkttype xt_tcpudp iptable_filter snd_hda_codec_hdmi=20
ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast=20
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack=20
ip6table_filter ip6_tables x_tables bnep arc4 xfs libcrc32c=20
snd_hda_codec_realtek intel_rapl snd_hda_codec_generic=20
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iwlmvm=20
snd_hda_intel raid1 irqbypass crct10dif_pclmul snd_hda_codec mac80211=20
crc32_pclmul snd_hda_core
[ 2128.130176]  ghash_clmulni_intel snd_hwdep pcbc snd_pcm iwlwifi=20
snd_timer dell_laptop aesni_intel md_mod hid_multitouch dell_wmi=20
iTCO_wdt aes_x86_64 snd rtsx_pci_ms iTCO_vendor_support btusb=20
crypto_simd uvcvideo dell_smbios btrtl glue_helper dell_smm_hwmon=20
wmi_bmof dcdbas joydev hci_uart cryptd pcspkr cfg80211 videobuf2_vmalloc =

memstick btbcm serdev videobuf2_memops r8169 btqca soundcore btintel=20
videobuf2_v4l2 mii int3403_thermal i2c_i801 videobuf2_core videodev=20
bluetooth battery ac sparse_keymap ecdh_generic fan thermal idma64=20
pinctrl_sunrisepoint pinctrl_intel tpm_crb tpm_tis tpm_tis_core tpm=20
processor_thermal_device intel_lpss_acpi intel_soc_dts_iosf=20
int3402_thermal dell_rbtn int340x_thermal_zone mei_me rfkill=20
int3400_thermal intel_lpss_pci acpi_pad mei acpi_thermal_rel intel_lpss=20
intel_pch_thermal
[ 2128.130252]  acpi_als kfifo_buf shpchp industrialio btrfs xor=20
zstd_decompress zstd_compress xxhash hid_generic usbhid i915 raid6_pq=20
rtsx_pci_sdmmc mmc_core mxm_wmi crc32c_intel i2c_algo_bit drm_kms_helper =

syscopyarea sysfillrect sysimgblt xhci_pci fb_sys_fops serio_raw=20
xhci_hcd rtsx_pci drm usbcore wmi video i2c_hid button sg dm_multipath=20
dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua
[ 2128.130300] CPU: 6 PID: 2310 Comm: pvrusb2-context Tainted: G=20
C O    4.14.6-1.g45f120a-default #1
[ 2128.130303] Hardware name: Dell Inc. Inspiron 7559/0H0CC0, BIOS 1.1.8 =

04/17/2016
[ 2128.130306] task: ffff880cae4f6000 task.stack: ffffb3a7c2548000
[ 2128.130320] RIP: 0010:pvr2_v4l2_internal_check+0x41/0x60 [pvrusb2]
[ 2128.130324] RSP: 0018:ffffb3a7c254bec8 EFLAGS: 00010246
[ 2128.130328] RAX: 0000000000000000 RBX: ffff880caf05e780 RCX:=20
ffffffffc0ffe970
[ 2128.130331] RDX: ffff880c90ca1b60 RSI: 0000000000000001 RDI:=20
0000000000000000
[ 2128.130334] RBP: ffff880cac83eb00 R08: ffffffffc1016a78 R09:=20
00000000000003d2
[ 2128.130337] R10: 00000000000003a9 R11: 00000000003d0900 R12:=20
ffffb3a7c24ffc18
[ 2128.130340] R13: ffff880cae4f6000 R14: 0000000000000000 R15:=20
ffffffffc1000ae0
[ 2128.130344] FS:  0000000000000000(0000) GS:ffff880cc1d80000(0000)=20
knlGS:0000000000000000
[ 2128.130347] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2128.130350] CR2: 0000000000000360 CR3: 000000024ec09005 CR4:=20
00000000003606e0
[ 2128.130354] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[ 2128.130357] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:=20
0000000000000400
[ 2128.130359] Call Trace:
[ 2128.130378]  pvr2_context_thread_func+0xa6/0x2a0 [pvrusb2]
[ 2128.130388]  ? finish_wait+0x80/0x80
[ 2128.130394]  kthread+0x118/0x130
[ 2128.130399]  ? kthread_create_on_node+0x40/0x40
[ 2128.130406]  ret_from_fork+0x25/0x30
[ 2128.130412] Code: 8b 7f 38 e8 d2 e4 ff ff 48 8b 7b 40 e8 c9 e4 ff ff=20
48 8b 43 38 48 8b 90 60 03 00 00 48 05 60 03 00 00 48 39 d0 75 d6 48 8b=20
43 40 <48> 8b 90 60 03 00 00 48 05 60 03 00 00 48 39 d0 75 c0 48 89 df
[ 2128.130491] RIP: pvr2_v4l2_internal_check+0x41/0x60 [pvrusb2] RSP:=20
ffffb3a7c254bec8
[ 2128.130494] CR2: 0000000000000360
[ 2128.130499] ---[ end trace b7d1a2a4867177f2 ]---

Upon reconnect the device is no longer recognized by the driver and no=20
firmware is uploaded:

[ 2135.323115] usb 1-1: new high-speed USB device number 7 using xhci_hcd=

[ 2135.481292] usb 1-1: New USB device found, idVendor=3D2040, idProduct=3D=
7300
[ 2135.481302] usb 1-1: New USB device strings: Mfr=3D1, Product=3D2,=20
SerialNumber=3D3
[ 2135.481306] usb 1-1: Product: WinTV
[ 2135.481310] usb 1-1: Manufacturer: Hauppauge
[ 2135.481313] usb 1-1: SerialNumber: 7300-00-F04BADA0
[ 2135.482726] pvrusb2: Hardware description: WinTV HVR-1900 Model 73xxx

This effectively breaks the driver until after a reboot of the kernel.=20
Can this be fixed by simply adding respective checks in the function=20
itself or is this a part of a bigger issue?

Thanks,
Oleksandr


--------------ms070602020900060600030204
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
ATAcBgkqhkiG9w0BCQUxDxcNMTcxMjE1MjMwMjU2WjAvBgkqhkiG9w0BCQQxIgQgPmGShAf5
CR9Zm6T4vj6DghXmD2DknoKbXJxQPNAE7AYwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQME
ASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0D
AgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBpwYJKwYBBAGCNxAEMYGZMIGWMIGFMQsw
CQYDVQQGEwJERTEoMCYGA1UEChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEM
MAoGA1UECxMDWklIMRwwGgYDVQQDExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJKoZIhvcN
AQkBFhFwa2lAdHUtZHJlc2Rlbi5kZQIMHKBbuYDarFdbIzauMIGpBgsqhkiG9w0BCRACCzGB
maCBljCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0
IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEg
MB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUCDBygW7mA2qxXWyM2rjANBgkqhkiG
9w0BAQEFAASCAQCd6gD0lqciwZL1Ox7bbdfzpn2H9+C4ZGsAcfwzaP8AScX6Vn24YykUYCZw
/pE+I8mT+a+IjC3LFAK5pCNy0jIqu4kqkTQ3fLLF8VLXpzzbxaui6Xd/dk6jfCfGH0QEEI+C
Jd9i4XV2H9ndhSXwBrxALCo18Fa27M9aGybGsomoBd/9l92d7/x4cnnOinc5n4s2GVZCtZtg
jWfd5k3pVkGsz11F0oqdZI5sH/kQcyUgiJ+fxrq2XImABfMEdAxA2YdxcY1O81/AJJEg/Qtq
HjTAfwuE1N9b6+aKZraQ+tVAsBm/FrbM495UyUpNpkfAS2oAtXFzpEjGX0NftUhzoukhAAAA
AAAA
--------------ms070602020900060600030204--
