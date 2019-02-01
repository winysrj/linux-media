Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72868C4151A
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 04:19:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CDD320870
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 04:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfBAETZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 23:19:25 -0500
Received: from 84.120.0.236.static.user.ono.com ([84.120.0.236]:34662 "EHLO
        sempati.menos4" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727813AbfBAETY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 23:19:24 -0500
X-Greylist: delayed 1543 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2019 23:19:24 EST
Received: from javier by sempati.menos4 with local (Exim 4.89)
        (envelope-from <javier@jasp.net>)
        id 1gpPta-0007cF-U8
        for linux-media@vger.kernel.org; Fri, 01 Feb 2019 04:53:39 +0100
Message-ID: <1548993218.1967.23.camel@jasp.net>
Subject: ZBar: Move development to GitHub
From:   Javier Serrano Polo <javier@jasp.net>
Reply-To: javier--ZDpp3NWAUi4iojWgtC3QwkB5th4T5J@jasp.net
To:     linux-media@vger.kernel.org
Date:   Fri, 01 Feb 2019 04:53:38 +0100
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-zriM9jZjxxAxawJm01PA"
X-Mailer: Evolution 3.22.6-1+deb9u1jasp2 
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--=-zriM9jZjxxAxawJm01PA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear list,

I maintain a fork of ZBar. Following a reply from James Hilliard and
according to Wikipedia edition from Mauro Carvalho Chehab, this team
stands as the new upstream.

Please consider to continue development on GitHub, since the
communication system is more friendly and there are continuous
integration builds. If you agree, I will create a GitHub organization
and import your repository along with my patches.

I await your answer.
Thank you.
--=-zriM9jZjxxAxawJm01PA
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCCtgw
ggTuMIID1qADAgECAhAoU7pCDzLt9W7P9nQHDQdNMA0GCSqGSIb3DQEBCwUAMHUxCzAJBgNVBAYT
AklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGllbnQgQ0EwHhcNMTYw
NTMwMTkwNTQ4WhcNMTkwODMwMTkwNTQ4WjA6MRgwFgYDVQQDDA9qYXZpZXJAamFzcC5uZXQxHjAc
BgkqhkiG9w0BCQEWD2phdmllckBqYXNwLm5ldDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBALkB0YjaCRhTKOn30V5s9Tr2c2oTPNPauRumMBzjF8tglW9kYWm44rUObZu7SOQzKjy959Ic
5R8Lqkp8NLjw9wp/eX7NjMiX4bcPdjcFUVSgXwN+VoVVYXN724Wbio64AD7qNgYjyfBGXaf/bImW
re1ofzqPK6xrbnZHGrnFRm274KKBoGmcm81N/g1mUZfikEM7AMyKIgcxw60aGPkSk2BPZnKqDooh
rHfrXf4q29vMMdy3EJmjeE2B3F49MmWE8+X7W6KsmyYI9RjN85sxBC8Utamds5P3Cv58NIkQw+ch
izFbBXHXQ7jRCEIIymOtv229U69Uqgc8y8aI7ZMhEpUCAwEAAaOCAbMwggGvMA4GA1UdDwEB/wQE
AwIEsDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwCQYDVR0TBAIwADAdBgNVHQ4EFgQU
MIX/u4biXYwKCdAPtPblwne2ZzEwHwYDVR0jBBgwFoAUJIFsOWG+SQ+PtxtGK8kotSdIbWgwbwYI
KwYBBQUHAQEEYzBhMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5zdGFydHNzbC5jb20wOQYIKwYB
BQUHMAKGLWh0dHA6Ly9haWEuc3RhcnRzc2wuY29tL2NlcnRzL3NjYS5jbGllbnQxLmNydDA4BgNV
HR8EMTAvMC2gK6AphidodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9zY2EtY2xpZW50MS5jcmwwGgYD
VR0RBBMwEYEPamF2aWVyQGphc3AubmV0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wu
Y29tLzBHBgNVHSAEQDA+MDwGCysGAQQBgbU3AQIFMC0wKwYIKwYBBQUHAgEWH2h0dHBzOi8vd3d3
LnN0YXJ0c3NsLmNvbS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggEBAKkoS2haC6/PxI3Z/T4LOsVz
ZytknU4q2KWD7sDt9rviyqNMV09UZ3BRjtMV0G7VtsHd/ILgABkywYHGSInl0q+rX/VkFzmBgAdD
SCIZdu+XWLMvjSD1qhcImyESS7fhXPGWvHSUc6LUscViV5D1qzf3D2NDK8FKCwaD0huhE73cxp0x
VnygR/WXgrWgy7nZmPsyuYQ2fUXTev5wcZ6ye1FJz3idmUeEvzKk5VfRXJQSOatQjm8urRFXOqg8
Vr6gzzVALPMiKfCXzbdR02MyE5kUZWVCSrUMbLWIFq4RCFRtLQ359AGIF40Z2z7EPJxLGo4o1Jvb
2AbQ05YmA8cy5M0wggXiMIIDyqADAgECAhBrp4p9CteI1lEK+Vnk57ThMA0GCSqGSIb3DQEBCwUA
MH0xCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUg
RGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xNTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYT
AklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMSBDbGllbnQgQ0EwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC9fdr3w6J9g/Zbgv3bW1+uHht1wLUZr5gkrLtXedg1
7AkefMyUGwrQdvwObhajcVmnKVxhrUwkZPXRAwZZosRHfEIi5FH7x6SV/8Sp5lZEuiMnvMFG2MzL
A84J6Ws5T4NfXZ0qn4TPgnr3X2vPVS51M7Ua9nIJgn8jvTra4eyyQzxvuA/GZwKg7VQfDCmCS+kI
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
jnQyPEgvvUKK4/AQ+oH+WhgAAAAAAAA=


--=-zriM9jZjxxAxawJm01PA--
