Return-Path: <SRS0=HTTW=RT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EC9C10F03
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 10:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58F76218FC
	for <linux-media@archiver.kernel.org>; Sat, 16 Mar 2019 10:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=lucaceresoli.net header.i=@lucaceresoli.net header.b="EelNTJJV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfCPKXs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Mar 2019 06:23:48 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:42783 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbfCPKXs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Mar 2019 06:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lucaceresoli.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:References:Cc:To:Subject:From:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tkOT0nuAv6lJ5llCx8U6HocKuqVW1sm5ZiSQvwWZyEg=; b=EelNTJJVeHvv6GmnFu4j/oGlYc
        0x8o6jywZ3bswsOT/gZvx6fZdJxYgU8wh0M4GAZkC2mI2BEReo3rVtDkL4w518u0KmyyDbBVI28/p
        F8MDvo8OKP7kRNWvB0m7/zK9Mh9tKR7xVMonkkC+Oy10UAvNSlLgAOsuPCALv35Vo5uY=;
Received: from [212.124.169.105] (port=45644 helo=[192.168.77.66])
        by hostingweb31.netsons.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@lucaceresoli.net>)
        id 1h56Tf-00HJoL-HC; Sat, 16 Mar 2019 11:23:43 +0100
From:   Luca Ceresoli <luca@lucaceresoli.net>
Subject: Re: [PATCH v3 26/31] adv748x: csi2: add internal routing
 configuration
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo@jmondi.org>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-27-jacopo+renesas@jmondi.org>
 <4f5b5763-be90-4040-7d55-986471168de1@lucaceresoli.net>
 <20190315094538.bs5ecsdzndrxjdbb@uno.localdomain>
 <20190315100613.avmsmavdraxetkzl@kekkonen.localdomain>
Message-ID: <28dbf2c7-2834-2bae-d56e-43e50d763c9f@lucaceresoli.net>
Date:   Sat, 16 Mar 2019 11:23:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190315100613.avmsmavdraxetkzl@kekkonen.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca@lucaceresoli.net
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo, Sakari,

On 15/03/19 11:06, Sakari Ailus wrote:
> Hi Luca, Jacopo,
>=20
> On Fri, Mar 15, 2019 at 10:45:38AM +0100, Jacopo Mondi wrote:
>> Hi Luca,
>>
>> On Thu, Mar 14, 2019 at 03:45:27PM +0100, Luca Ceresoli wrote:
>>> Hi,
>>>
>>> begging your pardon for the noob question below...
>>>
>>
>> Let a noob help another noob then
>>
>>> On 05/03/19 19:51, Jacopo Mondi wrote:
>>>> From: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
>>>>
>>>> Add support to get and set the internal routing between the adv748x
>>>> CSI-2 transmitters sink pad and its multiplexed source pad. This rou=
ting
>>>> includes which stream of the multiplexed pad to use, allowing the us=
er
>>>> to select which CSI-2 virtual channel to use when transmitting the
>>>> stream.
>>>>
>>>> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragna=
tech.se>
>>>> Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>>>> ---
>>>>  drivers/media/i2c/adv748x/adv748x-csi2.c | 65 +++++++++++++++++++++=
+++
>>>>  1 file changed, 65 insertions(+)
>>>>
>>>> diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/medi=
a/i2c/adv748x/adv748x-csi2.c
>>>> index d8f7cbee86e7..13454af72c6e 100644
>>>> --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
>>>> +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
>>>> @@ -14,6 +14,8 @@
>>>>
>>>>  #include "adv748x.h"
>>>>
>>>> +#define ADV748X_CSI2_ROUTES_MAX 4
>>>> +
>>>>  struct adv748x_csi2_format {
>>>>  	unsigned int code;
>>>>  	unsigned int datatype;
>>>> @@ -253,10 +255,73 @@ static int adv748x_csi2_get_frame_desc(struct =
v4l2_subdev *sd, unsigned int pad,
>>>>  	return 0;
>>>>  }
>>>>
>>>> +static int adv748x_csi2_get_routing(struct v4l2_subdev *sd,
>>>> +				    struct v4l2_subdev_krouting *routing)
>>>> +{
>>>> +	struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
>>>> +	struct v4l2_subdev_route *r =3D routing->routes;
>>>> +	unsigned int vc;
>>>> +
>>>> +	if (routing->num_routes < ADV748X_CSI2_ROUTES_MAX) {
>>>> +		routing->num_routes =3D ADV748X_CSI2_ROUTES_MAX;
>>>> +		return -ENOSPC;
>>>> +	}
>>>> +
>>>> +	routing->num_routes =3D ADV748X_CSI2_ROUTES_MAX;
>>>> +
>>>> +	for (vc =3D 0; vc < ADV748X_CSI2_ROUTES_MAX; vc++) {
>>>> +		r->sink_pad =3D ADV748X_CSI2_SINK;
>>>> +		r->sink_stream =3D 0;
>>>> +		r->source_pad =3D ADV748X_CSI2_SOURCE;
>>>> +		r->source_stream =3D vc;
>>>> +		r->flags =3D vc =3D=3D tx->vc ? V4L2_SUBDEV_ROUTE_FL_ACTIVE : 0;
>>>> +		r++;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static int adv748x_csi2_set_routing(struct v4l2_subdev *sd,
>>>> +				    struct v4l2_subdev_krouting *routing)
>>>> +{
>>>> +	struct adv748x_csi2 *tx =3D adv748x_sd_to_csi2(sd);
>>>> +	struct v4l2_subdev_route *r =3D routing->routes;
>>>> +	unsigned int i;
>>>> +	int vc =3D -1;
>>>> +
>>>> +	if (routing->num_routes > ADV748X_CSI2_ROUTES_MAX)
>>>> +		return -ENOSPC;
>>>> +
>>>> +	for (i =3D 0; i < routing->num_routes; i++) {
>>>> +		if (r->sink_pad !=3D ADV748X_CSI2_SINK ||
>>>> +		    r->sink_stream !=3D 0 ||
>>>> +		    r->source_pad !=3D ADV748X_CSI2_SOURCE ||
>>>> +		    r->source_stream >=3D ADV748X_CSI2_ROUTES_MAX)
>>>> +			return -EINVAL;
>>>> +
>>>> +		if (r->flags & V4L2_SUBDEV_ROUTE_FL_ACTIVE) {
>>>> +			if (vc !=3D -1)
>>>> +				return -EMLINK;
>>>> +
>>>> +			vc =3D r->source_stream;
>>>> +		}
>>>> +		r++;
>>>> +	}
>>>> +
>>>> +	if (vc !=3D -1)
>>>> +		tx->vc =3D vc;
>>>> +
>>>> +	adv748x_csi2_set_virtual_channel(tx, tx->vc);
>>>> +
>>>> +	return 0;
>>>> +}
>>>
>>> Not specific to this patch but rather to the set_routing idea as a
>>> whole: can the set_routing ioctl be called while the stream is runnin=
g?
>>>
>>> If it cannot, I find it a limiting factor for nowadays use cases. I a=
lso
>>> didn't find where the ioctl is rejected.
>>>
>>
>> The framework does not make assumptions about that at the moment.
>>
>>> If it can, then shouldn't this function call s_stream(stop) through t=
he
>>> sink pad whose route becomes disabled, and a s_stream(start) through =
the
>>> one that gets enabled?
>>>
>>
>> If I got this right, you're here rightfully pointing out that changing=

>> the routing between pads in an entity migh impact the pipeline as a
>> whole, and this would require, to activate/deactivate devices that
>> where not part of the pipeline.
>=20
> I'd say that ultimately this depends on the devices themselves, whether=

> they support this or not. In practice I don't think we have any such ca=
ses
> at the moment, but it's possible in principle. Changes on the framework=
 may
> well be needed but likely the biggest complications will still be in
> drivers supporting that.

I understand V4L2 currently does not support changing a pipeline that is
running. However there are many use cases that would require it.

Most of the use cases that come to my mind involve a multiplexer with
multiple inputs, one of which can be selected to be forwarded. In those
cases s_routing deselects an input and selects another one. How the can
we handle such cases without sending a s_stream on the two upstreams?
Having all possible inputs always running is not a real solution.

> The media links have a dynamic flag for this purpose but I don't think =
it's
> ever been used.
>=20
>>
>> This is probably the wrong patch to use an example, as this one is for=

>> a multiplexed interface, where there is no need to go through an
>> s_stream() for the two CSI-2 endpoints, but as you pointed out in our
>> brief offline chat, the AFE->TX routing example for this very device
>> is a good one: if we change the analogue source that is internally
>> routed to the CSI-2 output of the adv748x, do we need to s_stream(1)
>> the now routed entity and s_stream(0) on the not not-anymore-routed
>> one?
>>
>> My gut feeling is that this is up to userspace, as it should know
>> what are the requirements of the devices in the system, but this mean
>> going through an s_stream(0)/s_stream(1) sequence on the video device,=

>> and that would interrupt the streaming for sure.
>>
>> At the same time, I don't feel too much at ease with the idea of
>> s_routing calling s_stream on the entity' remote subdevices, as this
>> would skip the link format validation that media_pipeline_start()
>> performs.
>=20
> The link validation must be done in this case as well, it may not be
> simply skipped.

Agreed.

The routing VS pipeline validation point is a very important one. The
current proposed workflow is:

 1. the pipeline is validated as a whole, having knowledge of all the
    entities
 2. streaming is started
 3. s_routing is called on an entity (not on the pipeline!)

Now the s_routing function in the entity driver is not in a good
position to validate the candidate future pipeline as a whole.

Naively I'd say there are two possible solutions:

 1. the s_routing reaches the pipeline first, then the new pipeline is
    computed and verified, and if verification succeeds it is applied
 2. a partial pipeline verification mechanism is added, so the entity
    receiving a s_routing request to e.g. change the sink pad can invoke
    a verification on the part of pipeline that is about to be
    activated, and if verification succeeds it is applied

Somehow I suspect neither is trivial...

--=20
Luca


