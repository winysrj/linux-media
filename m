Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QNdY8i023738
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 19:39:34 -0400
Received: from mail9.dslextreme.com (mail9.dslextreme.com [66.51.199.94])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2QNdNm7008844
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 19:39:24 -0400
Mime-Version: 1.0 (Apple Message framework v624)
In-Reply-To: <1206573402.3912.50.camel@pc08.localdom.local>
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<200803161724.20459.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.00.26.941363@gimpelevich.san-francisco.ca.us>
	<200803161840.37910.peter.missel@onlinehome.de>
	<pan.2008.03.16.17.49.51.923202@gimpelevich.san-francisco.ca.us>
	<1206573402.3912.50.camel@pc08.localdom.local>
Message-Id: <653f28469c9babb5326973c119fd78db@gimpelevich.san-francisco.ca.us>
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Date: Wed, 26 Mar 2008 16:39:17 -0700
To: video4linux-list@redhat.com
Subject: Re: [PATCH] Re: LifeVideo To-Go Cardbus, tuner problems
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1903317399=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--===============1903317399==
Content-Type: multipart/signed; micalg=sha1; boundary=Apple-Mail-128-634290749;
	protocol="application/pkcs7-signature"


--Apple-Mail-128-634290749
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed

On Mar 26, 2008, at 4:16 PM, hermann pitton wrote:

> how do you consider to continue on this.
>
> Peter, we had discussed about the composite over s-video input here,
> when Glen Gray added his OEM version of the card. From the original 
> one,
> without a working tuner at that time, vmux=0 should have been a valid
> option, but neither the contributor nor anybody else was reachable at
> that time. So we left it, don't remember offhand what Glen had with it.
>
> On almost all cards with s-video there is composite over s-video, it
> doesn't cost a single cent to provide it. Daniel, do you have it?
> Works also with s-video plugged.
>
> If not, and Peter seems to have seen such, we remove it, else keep it
> and add the card to auto detection. Don't mess around with spaces after
> commas on recently added, cards. It is some recent checkpatch.pl
> annoyance.
>
> Just add the card, maybe the likely existing OEM saa7133 stuff Peter
> suggests. And add a Signed-off-by !

I have since returned the card to its owner, but I did try the 
composite-over-S setting, and I saw the S-video source when I did that, 
but in monochrome. Therefore, I can only assume that setting works the 
way it's designed, because I did not bother to jury-rig an S-video 
connector that carries a true composite signal. I already had a 
Signed-off-by in what I submitted, and you're welcome to carry that 
forward to changes you make to the patch. As far as I'm concerned, 
5169/1502 needs to be recognized as card 39, notwithstanding any 
differences from 5168/1502.
-- 
"No gnu's is good gnu's."   --Gary Gnu, "The Great Space Coaster"
--Apple-Mail-128-634290749
Content-Transfer-Encoding: base64
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Disposition: attachment;
	filename=smime.p7s

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGTTCCAwYw
ggJvoAMCAQICEBDAn4gnWUUrGUQfb8V+HHgwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDgxNDIxNDI0MFoXDTA4MDgxMzIxNDI0
MFowWDEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjE1MDMGCSqGSIb3DQEJARYmZGFu
aWVsQGdpbXBlbGV2aWNoLnNhbi1mcmFuY2lzY28uY2EudXMwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQC1tNDJEtPQwKpOCFm7pKuWBM6JcmS6UFAMEYkPx+x3yrVmgOCyTF2grHmX5+4M
B1QCN2JHgv3Ui6TXF82F7YSNCBHUagmiZlFKTaiv1cPgUbuKWZ0bndsL83qY6gbpqevfdKrvbM9j
Rru/wT4RnrSU7uzBCcBEMMHZ8QjdnG5BlWkjxaiWM/OpqlI4HypEKEpE1PYMsgPl6OC6amlYlNBm
Yyi03YuR50PAD+i7mw94WTyn7wWkTmgjBUMKuJlkybuUhWGiAheYZmE4cUQJgngRRraWQoYynPIY
tSbasNKryiJAvm1o4++4bgTaR/H2gCUeCBJQaaUIkRrhyO4zbJChAgMBAAGjQzBBMDEGA1UdEQQq
MCiBJmRhbmllbEBnaW1wZWxldmljaC5zYW4tZnJhbmNpc2NvLmNhLnVzMAwGA1UdEwEB/wQCMAAw
DQYJKoZIhvcNAQEFBQADgYEAcRGo2Rl+WJ+DoVDg/gTpcruGaHnMPBsQ4/0d12+k5aV3aH+pu2tz
6lFtKJSM2gTYloELHlIffhkYQcb/Eu/R9utBj3lHoweCPHDAmPxfd2jvHY/aAtM9qvtFN5Ue/5mq
c6VdAl2tWmHynZyaxwp7yn+pS+iwExCNyx5E1mxVFGQwggM/MIICqKADAgECAgENMA0GCSqGSIb3
DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlD
YXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9DZXJ0aWZpY2F0
aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwg
Q0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20wHhcNMDMwNzE3
MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENv
bnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElz
c3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f
6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYk
KhPPK9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGj
gZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLnRo
YXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYwKQYDVR0R
BCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEBBQUAA4GBAEiM
0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFhYsPZOhl+hLGZ
GwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVNd+NWIXiC3CEZ
Nd4ksdMdRv9dX2VPMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3Rl
IENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWls
IElzc3VpbmcgQ0ECEBDAn4gnWUUrGUQfb8V+HHgwCQYFKw4DAhoFAKCCAW8wGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDgwMzI2MjMzOTE3WjAjBgkqhkiG9w0BCQQx
FgQUB6z4eNgFPiNTSxuiJn4EOv4DmYUwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAQwJ+IJ1lFKxlEH2/Ffhx4MIGHBgsqhkiG9w0B
CRACCzF4oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkp
IEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAQwJ+I
J1lFKxlEH2/Ffhx4MA0GCSqGSIb3DQEBAQUABIIBACwn+OWlfdSrdHo8DXWqhiaD+AJKY79JssAb
yjGDG/0Ka4zqoLn5wYuLwDBfsVJHdrAa/aG7hI/E0i63AzXNVVqTkJV0IXsJCslD8V3AKUVBnk+B
D6pD8iZwH42uZf5A93xIVrU4zJuzEiQzgnQNmOs71u+JN3RPkL7soKs8CAmIqs1jtma/H30oaIVp
X6qAf+eXV49Rhpzx37km/t/gijaycvBWn9ixWEDDy7j1Umq8hHEkNXpbbnW9iLBihdgkuEHIbrFK
kGLwoYiwcoTYZI31sNlTEpZ9t4PdpZ416UJFy2PkY2In16EE0SwG7dZAyXXfPCuhHzk3obisThh0
WxQAAAAAAAA=

--Apple-Mail-128-634290749--


--===============1903317399==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1903317399==--
