Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:40898 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755070AbeEXFrz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 01:47:55 -0400
Received: by mail-pl0-f67.google.com with SMTP id t12-v6so348984plo.7
        for <linux-media@vger.kernel.org>; Wed, 23 May 2018 22:47:55 -0700 (PDT)
Date: Wed, 23 May 2018 22:47:50 -0700
From: Benson Leung <bleung@google.com>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com, sadolfsson@google.com,
        felixe@google.com, darekm@google.com, marcheu@chromium.org,
        fparent@baylibre.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Stefan Adolfsson <sadolfsson@chromium.org>, bleung@chromium.org
Subject: Re: [PATCH v2 3/5] mfd: cros-ec: Introduce CEC commands and events
 definitions.
Message-ID: <20180524054750.GA245608@decatoncale.mtv.corp.google.com>
References: <1526648704-16873-1-git-send-email-narmstrong@baylibre.com>
 <1526648704-16873-4-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1526648704-16873-4-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil, Hi Stefan,

On Fri, May 18, 2018 at 03:05:02PM +0200, Neil Armstrong wrote:
> The EC can expose a CEC bus, this patch adds the CEC related definitions
> needed by the cros-ec-cec driver.
> Having a 16 byte mkbp event size makes it possible to send CEC
> messages from the EC to the AP directly inside the mkbp event
> instead of first doing a notification and then a read.
>=20
> Signed-off-by: Stefan Adolfsson <sadolfsson@chromium.org>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>

It looks like this change squashes together this chromeos-4.4 CL
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/=
1061879
and some other new changes to add cec to cros_ec_commands.

Could you separate the two? One patch that's as close to Stefan's
which introduces the 16 byte mkbp, and a second one that
adds the HDMI CEC commands?=20

Thanks,
Benson
> ---
>  drivers/platform/chrome/cros_ec_proto.c | 40 +++++++++++++----
>  include/linux/mfd/cros_ec.h             |  2 +-
>  include/linux/mfd/cros_ec_commands.h    | 80 +++++++++++++++++++++++++++=
++++++
>  3 files changed, 112 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/c=
hrome/cros_ec_proto.c
> index e7bbdf9..c4f6c44 100644
> --- a/drivers/platform/chrome/cros_ec_proto.c
> +++ b/drivers/platform/chrome/cros_ec_proto.c
> @@ -504,10 +504,31 @@ int cros_ec_cmd_xfer_status(struct cros_ec_device *=
ec_dev,
>  }
>  EXPORT_SYMBOL(cros_ec_cmd_xfer_status);
> =20
> +static int get_next_event_xfer(struct cros_ec_device *ec_dev,
> +			       struct cros_ec_command *msg,
> +			       int version, uint32_t size)
> +{
> +	int ret;
> +
> +	msg->version =3D version;
> +	msg->command =3D EC_CMD_GET_NEXT_EVENT;
> +	msg->insize =3D size;
> +	msg->outsize =3D 0;
> +
> +	ret =3D cros_ec_cmd_xfer(ec_dev, msg);
> +	if (ret > 0) {
> +		ec_dev->event_size =3D ret - 1;
> +		memcpy(&ec_dev->event_data, msg->data, ec_dev->event_size);
> +	}
> +
> +	return ret;
> +}
> +
>  static int get_next_event(struct cros_ec_device *ec_dev)
>  {
>  	u8 buffer[sizeof(struct cros_ec_command) + sizeof(ec_dev->event_data)];
>  	struct cros_ec_command *msg =3D (struct cros_ec_command *)&buffer;
> +	static int cmd_version =3D 1;
>  	int ret;
> =20
>  	if (ec_dev->suspended) {
> @@ -515,18 +536,19 @@ static int get_next_event(struct cros_ec_device *ec=
_dev)
>  		return -EHOSTDOWN;
>  	}
> =20
> -	msg->version =3D 0;
> -	msg->command =3D EC_CMD_GET_NEXT_EVENT;
> -	msg->insize =3D sizeof(ec_dev->event_data);
> -	msg->outsize =3D 0;
> +	if (cmd_version =3D=3D 1) {
> +		ret =3D get_next_event_xfer(ec_dev, msg, cmd_version,
> +				sizeof(struct ec_response_get_next_event_v1));
> +		if (ret < 0 || msg->result !=3D EC_RES_INVALID_VERSION)
> +			return ret;
> =20
> -	ret =3D cros_ec_cmd_xfer(ec_dev, msg);
> -	if (ret > 0) {
> -		ec_dev->event_size =3D ret - 1;
> -		memcpy(&ec_dev->event_data, msg->data,
> -		       sizeof(ec_dev->event_data));
> +		/* Fallback to version 0 for future send attempts */
> +		cmd_version =3D 0;
>  	}
> =20
> +	ret =3D get_next_event_xfer(ec_dev, msg, cmd_version,
> +				  sizeof(struct ec_response_get_next_event));
> +
>  	return ret;
>  }
> =20
> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index f36125e..32caef3 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -147,7 +147,7 @@ struct cros_ec_device {
>  	bool mkbp_event_supported;
>  	struct blocking_notifier_head event_notifier;
> =20
> -	struct ec_response_get_next_event event_data;
> +	struct ec_response_get_next_event_v1 event_data;
>  	int event_size;
>  	u32 host_event_wake_mask;
>  };
> diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cro=
s_ec_commands.h
> index f2edd99..16c3a2b 100644
> --- a/include/linux/mfd/cros_ec_commands.h
> +++ b/include/linux/mfd/cros_ec_commands.h
> @@ -804,6 +804,8 @@ enum ec_feature_code {
>  	EC_FEATURE_MOTION_SENSE_FIFO =3D 24,
>  	/* EC has RTC feature that can be controlled by host commands */
>  	EC_FEATURE_RTC =3D 27,
> +	/* EC supports CEC commands */
> +	EC_FEATURE_CEC =3D 35,
>  };
> =20
>  #define EC_FEATURE_MASK_0(event_code) (1UL << (event_code % 32))
> @@ -2078,6 +2080,12 @@ enum ec_mkbp_event {
>  	/* EC sent a sysrq command */
>  	EC_MKBP_EVENT_SYSRQ =3D 6,
> =20
> +	/* Notify the AP that something happened on CEC */
> +	EC_MKBP_CEC_EVENT =3D 8,
> +
> +	/* Send an incoming CEC message to the AP */
> +	EC_MKBP_EVENT_CEC_MESSAGE =3D 9,
> +
>  	/* Number of MKBP events */
>  	EC_MKBP_EVENT_COUNT,
>  };
> @@ -2093,12 +2101,31 @@ union ec_response_get_next_data {
>  	uint32_t   sysrq;
>  } __packed;
> =20
> +union ec_response_get_next_data_v1 {
> +	uint8_t   key_matrix[16];
> +
> +	/* Unaligned */
> +	uint32_t  host_event;
> +
> +	uint32_t   buttons;
> +	uint32_t   switches;
> +	uint32_t   sysrq;
> +	uint32_t   cec_events;
> +	uint8_t    cec_message[16];
> +} __packed;
> +
>  struct ec_response_get_next_event {
>  	uint8_t event_type;
>  	/* Followed by event data if any */
>  	union ec_response_get_next_data data;
>  } __packed;
> =20
> +struct ec_response_get_next_event_v1 {
> +	uint8_t event_type;
> +	/* Followed by event data if any */
> +	union ec_response_get_next_data_v1 data;
> +} __packed;
> +
>  /* Bit indices for buttons and switches.*/
>  /* Buttons */
>  #define EC_MKBP_POWER_BUTTON	0
> @@ -2828,6 +2855,59 @@ struct ec_params_reboot_ec {
>  /* Current version of ACPI memory address space */
>  #define EC_ACPI_MEM_VERSION_CURRENT 1
> =20
> +/***********************************************************************=
******/
> +/*
> + * HDMI CEC commands
> + *
> + * These commands are for sending and receiving message via HDMI CEC
> + */
> +#define MAX_CEC_MSG_LEN 16
> +
> +/* CEC message from the AP to be written on the CEC bus */
> +#define EC_CMD_CEC_WRITE_MSG 0x00B8
> +
> +/* Message to write to the CEC bus */
> +struct ec_params_cec_write {
> +	uint8_t msg[MAX_CEC_MSG_LEN];
> +} __packed;
> +
> +/* Set various CEC parameters */
> +#define EC_CMD_CEC_SET 0x00BA
> +
> +struct ec_params_cec_set {
> +	uint8_t cmd; /* enum cec_command */
> +	union {
> +		uint8_t enable;
> +		uint8_t address;
> +	};
> +} __packed;
> +
> +/* Read various CEC parameters */
> +#define EC_CMD_CEC_GET 0x00BB
> +
> +struct ec_params_cec_get {
> +	uint8_t cmd; /* enum cec_command */
> +} __packed;
> +
> +struct ec_response_cec_get {
> +	union {
> +		uint8_t enable;
> +		uint8_t address;
> +	};
> +} __packed;
> +
> +enum cec_command {
> +	/* CEC reading, writing and events enable */
> +	CEC_CMD_ENABLE,
> +	/* CEC logical address  */
> +	CEC_CMD_LOGICAL_ADDRESS,
> +};
> +
> +/* Events from CEC to AP */
> +enum mkbp_cec_event {
> +	EC_MKBP_CEC_SEND_OK			=3D 1 << 0,
> +	EC_MKBP_CEC_SEND_FAILED			=3D 1 << 1,
> +};
> =20
>  /***********************************************************************=
******/
>  /*
> --=20
> 2.7.4
>=20

--=20
Benson Leung
Staff Software Engineer
Chrome OS Kernel
Google Inc.
bleung@google.com
Chromium OS Project
bleung@chromium.org

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE6gYDF28Li+nEiKLaHwn1ewov5lgFAlsGUgYACgkQHwn1ewov
5lilCQ/6AjK9oxG0+ZKxZ8hyw6p3SoHgwZ38dum0f3LMsJW7xUZXhBW8HGktLRRc
dZtmLpa9RM69gUg8dPk16aNfFaSw+w0yqqdUoHFVmIttK/Aj8o4QPWSUnqa7Pkbb
8Gnqa8v+PC9e2Pft9mhqkQPwDDfN5NsPDgNgnFzJwgBA5GkHjG8Q3vtZoKK/qZUw
J8ltsrRgxwfTlAU9NYGrIBrhrPeGxSIwR/7fPBYTYdfd5B7rQ18qOoVZcBuwrUkv
wvW+Lb72EmFl97TmSNPlxywErU4UgqBhIQkm24ejkKYXCKTQ2XsZxA7Dgukd7taH
H7EZEpOVbVtgAUTnQ5yhpbQR+sszzGIDcEmEDzsZBdxgQa9Q1j+OXUMavnUYGCpl
dST6g4opvtZNc3PJejwAIqjjm5XNnjK2BSYsFK3X30Paic2+2mV9jNRG3FuxwkT3
XY27dU+8SX9VyvS9aPcJCqnzM2SpURB0ZNraoiZ9yYF2BolFV0eC8//sTD/AL6ZX
8n2G/9PmgQGPAVOEREV9GHklLd2dDvujVvWNB4rfbjUslRW7DoE7jDl4AaYIbzr6
thMhhxRh6MiLYIxP4a6AR64wX7Rc7X31BXAMNhhpNcz7ZQJ5GmsNy9evSpg8fmEF
gPTHAVENIuXO4ZjPbHUilXNNKDfdTOKuLCOI3JxIo4Dm6cobgPQ=
=QF2U
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
