Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E77C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 20:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECCE82084C
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 20:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=aampusa.onmicrosoft.com header.i=@aampusa.onmicrosoft.com header.b="RsWcL75N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfA2UWx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 15:22:53 -0500
Received: from mail-eopbgr690109.outbound.protection.outlook.com ([40.107.69.109]:21632
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727473AbfA2UWx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 15:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=aampusa.onmicrosoft.com; s=selector1-aampglobal-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gVt1HUgh4yCUMGekAnK6PbRhIbFxfGO0urvz3WfFlA=;
 b=RsWcL75NUfut1QeGC4LAdlM6lCncruZ1aDf9wokNLDNnmyCdNWPnvGDfehrKu2BbIFez5XdtuJnBlPHTJkddqQ2+oaJCDjm4z096Qj0UKckKwO5jTfFHKura9yi2NfjlB88sKI4o2u6vEOKIqJoabTIkotpCzVcFo0aa+pmK/Ug=
Received: from BL0PR07MB4115.namprd07.prod.outlook.com (52.132.10.149) by
 BL0PR07MB5700.namprd07.prod.outlook.com (20.177.243.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1558.21; Tue, 29 Jan 2019 20:22:48 +0000
Received: from BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::c899:a193:f06c:cba7]) by BL0PR07MB4115.namprd07.prod.outlook.com
 ([fe80::c899:a193:f06c:cba7%4]) with mapi id 15.20.1558.023; Tue, 29 Jan 2019
 20:22:48 +0000
From:   Ken Sloat <KSloat@aampglobal.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
CC:     "Eugen.Hristev@microchip.com" <Eugen.Hristev@microchip.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "Ludovic.Desroches@microchip.com" <Ludovic.Desroches@microchip.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ken Sloat <KSloat@aampglobal.com>
Subject: RE: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Topic: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
 documentation
Thread-Index: AQHUrzoN7XJuswIKkE+w1zxwJJXABKW1GOSAgAA2n1CAB4UdAIAJ7bdw
Date:   Tue, 29 Jan 2019 20:22:48 +0000
Message-ID: <BL0PR07MB4115CF2CA5F69C3963AC58BBAD970@BL0PR07MB4115.namprd07.prod.outlook.com>
References: <DM5PR07MB411967243FA1C96C1179071FAD9C0@DM5PR07MB4119.namprd07.prod.outlook.com>
 <20190123124538.5vfxhsyl2npy4jnp@valkosipuli.retiisi.org.uk>
In-Reply-To: <20190123124538.5vfxhsyl2npy4jnp@valkosipuli.retiisi.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=KSloat@aampglobal.com; 
x-originating-ip: [100.3.71.115]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR07MB5700;6:IEkYbPr4LlcweVje8nIExcznszVxrqXaNNH9rYH5ne3mspYdXuTGb/GzfEV23yDqh2She4X6OF3m5JZGdjh2CkYVsobGO1xNsdiBe64N+6lOlMj5gPQrN064Y2ofOuQL5IGOQqDmoyaWcnNXG/dypd2AWIBHtkVUOzcTDq5o87TWwOf1mXyCF7v/KlqAmyLWMAMftxFR00FDWBsITKRxw9ng0ErB/ocmqcdLics9BQ92vuEFdSYgG4doL7iYgvjocQ/dwSZox7sRjpcMffYee8MgA25pvVyr873B2hlNYldDYmibmQQZBon6KnERNMI0kuFtkWaei7i+oOd7KYZDM8vODKyBuFh9ovbACSxfgPYooughoeRMsQsLmB+unhgwyNPhbxWbfQQmbr6ay5NEeOQ4RW4P3uMaaqTh+oGwJDF/L0B3w7g4q8WdMNtT1fSG0EX3IRaYhImMHt9lcyLyGg==;5:oM1MG/rhzYJYUmEWQc+umRnltCH/QsYpm/HTVsi+hzBl5JmIHS0vWQiP3GfzaE8b+iYYOym34eKnsthPrk8ogwJvC31Rm6tALZ5iFBF1g+13pRmfZ0KUqOOSUVlmlGdtyDUe8ge5fImd2gHM9nejh3wVLK1VxTZ82pVODLAnqNXhGmB350ueuvPo0h07XfZce/h18J2swvUXLJiNY3TZtg==;7:hYNg6try70ZBOvxfS6SxAC8oVw4NKbUsjh8QajjIRkZBZpCHvPUMPbkWRU+JKMuFY45BMs7GG8vq46HU/zv3XUK8THIFDJxUmipGBykJBW4jrLUOh2lzOJXuuK5mAKOfyJfCiWI6UkCv5ONeGKi1WA==
x-ms-office365-filtering-correlation-id: 0b4a76b3-2892-4476-b8a6-08d68627893c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BL0PR07MB5700;
x-ms-traffictypediagnostic: BL0PR07MB5700:
x-microsoft-antispam-prvs: <BL0PR07MB5700905714B2D432392C78EFAD970@BL0PR07MB5700.namprd07.prod.outlook.com>
x-forefront-prvs: 093290AD39
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(346002)(376002)(136003)(396003)(199004)(189003)(13464003)(229853002)(81156014)(33656002)(26005)(102836004)(8676002)(25786009)(305945005)(446003)(14454004)(256004)(486006)(6116002)(81166006)(2906002)(53546011)(8936002)(186003)(316002)(76176011)(6506007)(3846002)(99286004)(14444005)(7696005)(54906003)(476003)(15650500001)(97736004)(86362001)(6436002)(71200400001)(71190400001)(72206003)(6916009)(74316002)(6246003)(105586002)(53936002)(107886003)(4326008)(9686003)(106356001)(55016002)(80792005)(7736002)(11346002)(478600001)(66066001)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR07MB5700;H:BL0PR07MB4115.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aampglobal.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o9HSyVgmzAzMHsc1j5ojirAyNYBHcTaeASOPf/tXttx9N7h2PD2LRqTIpHSD4kmRG3oJXZzFabvfOeM3iW/WJamqLHzlQup4IPP5R7gkGpBJWSoH/w0nKTg5v2YQrSkF0BPLUFJ7N5OBymbSs1DNjq4Z979PeZ4uNlmEci3F5Uapo0LvSmu+WdmuxP6oC5VWUBENw7ubXsP08omN8gmk8taTCdQWuRAU3rk3Kj4Z6hfwaRvi7p/IqWNwg1PYvUpsiMVaXG0HR/UBuAR14C96F9rfLyGFjTRl80gCfjuZOQNs2MTaxh88l9FRrT9SZLDu+8fnzEYsO5WVJsoYbGxGzCs5nxlFqpWHCt8V48CirFdG8XP5FM3QWDXmNT2wiIqhO3q3/pS+mOqOwehVnMKByimf7V2uRIZMSBggIAc8EuI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aampglobal.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4a76b3-2892-4476-b8a6-08d68627893c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2019 20:22:48.1937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e20e3a66-8b9e-46e9-b859-cb654c1ec6ea
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR07MB5700
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 04
X-MS-Exchange-CrossPremises-AuthSource: BL0PR07MB4115.namprd07.prod.outlook.com
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-TransportTrafficSubType: 
X-MS-Exchange-CrossPremises-SCL: 1
X-MS-Exchange-CrossPremises-messagesource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: 
X-MS-Exchange-CrossPremises-originalclientipaddress: 100.3.71.115
X-MS-Exchange-CrossPremises-transporttraffictype: Email
X-MS-Exchange-CrossPremises-transporttrafficsubtype: 
X-MS-Exchange-CrossPremises-antispam-scancontext: DIR:Originating;SFV:NSPM;SKIP:0;
X-MS-Exchange-CrossPremises-processed-by-journaling: Journal Agent
X-OrganizationHeadersPreserved: BL0PR07MB5700.namprd07.prod.outlook.com
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

> -----Original Message-----
> From: Sakari Ailus <sakari.ailus@iki.fi>
> Sent: Wednesday, January 23, 2019 7:46 AM
> Cc: Eugen.Hristev@microchip.com; mchehab@kernel.org;
> Nicolas.Ferre@microchip.com; alexandre.belloni@bootlin.com;
> Ludovic.Desroches@microchip.com; linux-media@vger.kernel.org;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH v2 2/2] media: atmel-isc: Update device tree binding
> documentation
>=20
> On Fri, Jan 18, 2019 at 06:05:23PM +0000, Ken Sloat wrote:
> > > -----Original Message-----
> > > From: Eugen.Hristev@xxxxxxxxxxxxx <Eugen.Hristev@xxxxxxxxxxxxx>
> > > Sent: Friday, January 18, 2019 9:40 AM
> > > To: Ken Sloat <KSloat@xxxxxxxxxxxxxx>
> > > Cc: mchehab@xxxxxxxxxx; Nicolas.Ferre@xxxxxxxxxxxxx;
> > > alexandre.belloni@xxxxxxxxxxx; Ludovic.Desroches@xxxxxxxxxxxxx;
> > > linux- media@xxxxxxxxxxxxxxx; devicetree@xxxxxxxxxxxxxxx
> > > Subject: Re: [PATCH v2 2/2] media: atmel-isc: Update device tree
> > > binding documentation
> > >
> > >
> > >
> > > On 18.01.2019 16:28, Ken Sloat wrote:
> > > > From: Ken Sloat <ksloat@xxxxxxxxxxxxxx>
> > > >
> > > > Update device tree binding documentation specifying how to enable
> > > > BT656 with CRC decoding.
> > > >
> > > > Signed-off-by: Ken Sloat <ksloat@xxxxxxxxxxxxxx>
> > > > ---
> > > >   Changes in v2:
> > > >   -Use correct media "bus-type" dt property.
> > > >
> > > >   Documentation/devicetree/bindings/media/atmel-isc.txt | 5 +++++
> > > >   1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/media/atmel-isc.txt
> > > > b/Documentation/devicetree/bindings/media/atmel-isc.txt
> > > > index bbe0e87c6188..2d4378dfd6c8 100644
> > > > --- a/Documentation/devicetree/bindings/media/atmel-isc.txt
> > > > +++ b/Documentation/devicetree/bindings/media/atmel-isc.txt
> > > > @@ -21,6 +21,11 @@ Required properties for ISC:
> > > >   - pinctrl-names, pinctrl-0
> > > >   	Please refer to pinctrl-bindings.txt.
> > > >
> > > > +Optional properties for ISC:
> > > > +- bus-type
> > > > +	When set to 6, Bt.656 decoding (embedded sync) with CRC decoding
> > > > +	is enabled.
> > > > +
> > >
> > > I don't think this patch is required at all actually, the binding
> > > complies to the video-interfaces bus specification which includes the
> parallel and bt.656.
> > >
> > > Would be worth mentioning below explicitly that parallel and bt.656
> > > are supported, or added above that also plain parallel bus is support=
ed ?
> > >
> > > >   ISC supports a single port node with parallel bus. It should
> > > > contain one
> > >
> > > here inside the previous line
> > Hi Eugen,
> >
> > Yes it's true adding new documentation here may be overkill, but yes
> > it should say something (as a user I always find it helpful if the docs=
 are
> more verbose than not).
> >
> > So per your suggestion, how about the simplified:
> > "ISC supports a single port node with parallel bus and optionally Bt.65=
6
> support."
> >
> > and I'll remit the other statements.
>=20
> Please still include the name of the property, as well as the valid value=
s for it
> (numeric as well as human-readable). The rest of the documentation should
> stay in video-interfaces.txt IMO --- this is documentation for the hardwa=
re
> only.
>=20
> --
> Regards,
>=20
> Sakari Ailus

Thanks Sakari for the feedback. So my original patch here would be valid as=
 is correct?

Thanks,
Ken Sloat

