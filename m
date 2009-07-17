Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45482 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933571AbZGQGRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 02:17:44 -0400
Message-ID: <4A601785.2020600@s5r6.in-berlin.de>
Date: Fri, 17 Jul 2009 08:17:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: Henrik Kurelid <henke@kurelid.se>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] firedtv: refine AVC debugging
References: <101260728ec51cc1ec78699fbb0e5c37.squirrel@mail.kurelid.se>
In-Reply-To: <101260728ec51cc1ec78699fbb0e5c37.squirrel@mail.kurelid.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Henrik Kurelid wrote:
> +static int debug_fcp_opcode_flag_set(unsigned int opcode,
> +                                    const u8 *data, int length)
> +{
> +       switch (opcode) {
> +       case AVC_OPCODE_VENDOR:                 break;
> +       case AVC_OPCODE_READ_DESCRIPTOR:        return avc_debug & AVC_DEBUG_READ_DESCRIPTOR;
> +       case AVC_OPCODE_DSIT:                   return avc_debug & AVC_DEBUG_DSIT;
> +       case AVC_OPCODE_DSD:                    return avc_debug & AVC_DEBUG_DSD;
> +       default:                                return 1;
> +       }
> +
> +       if (length < 7 ||
> +           data[3] != SFE_VENDOR_DE_COMPANYID_0 ||
> +           data[4] != SFE_VENDOR_DE_COMPANYID_1 ||
> +           data[5] != SFE_VENDOR_DE_COMPANYID_2)
> +               return 1;
> +
> +       switch (data[6]) {
> +       case SFE_VENDOR_OPCODE_REGISTER_REMOTE_CONTROL: return avc_debug & AVC_DEBUG_REGISTER_REMOTE_CONTROL;
> +       case SFE_VENDOR_OPCODE_LNB_CONTROL:             return avc_debug & AVC_DEBUG_LNB_CONTROL;
> +       case SFE_VENDOR_OPCODE_TUNE_QPSK:               return avc_debug & AVC_DEBUG_TUNE_QPSK;
> +       case SFE_VENDOR_OPCODE_TUNE_QPSK2:              return avc_debug & AVC_DEBUG_TUNE_QPSK2;
> +       case SFE_VENDOR_OPCODE_HOST2CA:                 return avc_debug & AVC_DEBUG_HOST2CA;
> +       case SFE_VENDOR_OPCODE_CA2HOST:                 return avc_debug & AVC_DEBUG_CA2HOST;
> +       }
> +       return 1;
> +}
> +
>  static void debug_fcp(const u8 *data, int length)
>  {
>         unsigned int subunit_type, subunit_id, op;
>         const char *prefix = data[0] > 7 ? "FCP <- " : "FCP -> ";
> 
> -       if (avc_debug & AVC_DEBUG_FCP_SUBACTIONS) {
> -               subunit_type = data[1] >> 3;
> -               subunit_id = data[1] & 7;
> -               op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
> +       subunit_type = data[1] >> 3;
> +       subunit_id = data[1] & 7;
> +       op = subunit_type == 0x1e || subunit_id == 5 ? ~0 : data[2];
> +       if (debug_fcp_opcode_flag_set(op, data, length)) {
>                 printk(KERN_INFO "%ssu=%x.%x l=%d: %-8s - %s\n",
[...]

Shouldn't the three return statements in debug_fcp_opcode_flag_set be 
'return 0' rather than one?
-- 
Stefan Richter
-=====-==--= -=== =---=
http://arcgraph.de/sr/
