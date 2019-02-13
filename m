Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A1FC282CE
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 19:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD1E8222D3
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 19:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=xilinx.onmicrosoft.com header.i=@xilinx.onmicrosoft.com header.b="dwlVl/wE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391797AbfBMTrI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 14:47:08 -0500
Received: from mail-eopbgr680071.outbound.protection.outlook.com ([40.107.68.71]:44000
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728965AbfBMTrI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 14:47:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+0bl5DBZkk+ykQIr3n7oXPSzcmzMPQ0coZizaHmxSCs=;
 b=dwlVl/wEX3EEXYfE/QSF1LjyCH/maLi5ik9hyB0p3TlgHCKEHdVwvz73FDTAZ27nFEL7PsIHDOgZIfjUVFfIkTe+iufC3Zj8pO0oX8ny/G58w0UE9NJ9EKQFjDrfiFjdF6wTy5F8i1lxXllDx+IWBwEZz9Ms3JQXwMosYUW7blQ=
Received: from MWHPR02CA0015.namprd02.prod.outlook.com (2603:10b6:300:4b::25)
 by BL2PR02MB2147.namprd02.prod.outlook.com (2a01:111:e400:c74b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1601.21; Wed, 13 Feb
 2019 19:47:02 +0000
Received: from BL2NAM02FT026.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::207) by MWHPR02CA0015.outlook.office365.com
 (2603:10b6:300:4b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1622.16 via Frontend
 Transport; Wed, 13 Feb 2019 19:47:01 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 BL2NAM02FT026.mail.protection.outlook.com (10.152.77.156) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1580.10
 via Frontend Transport; Wed, 13 Feb 2019 19:47:00 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gu0Um-0000sg-3X; Wed, 13 Feb 2019 11:47:00 -0800
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gu0Ug-0001cQ-Ug; Wed, 13 Feb 2019 11:46:55 -0800
Received: from xsj-pvapsmtp01 (xsj-pvapsmtp01.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x1DJkijW022545;
        Wed, 13 Feb 2019 11:46:44 -0800
Received: from [172.19.2.244] (helo=localhost)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <hyun.kwon@xilinx.com>)
        id 1gu0UW-0001br-0E; Wed, 13 Feb 2019 11:46:44 -0800
Date:   Wed, 13 Feb 2019 11:45:42 -0800
From:   Hyun Kwon <hyun.kwon@xilinx.com>
To:     Vishal Sagar <vishal.sagar@xilinx.com>
CC:     <laurent.pinchart@ideasonboard.com>, <mchehab@kernel.org>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>, <michals@xilinx.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <sakari.ailus@linux.intel.com>, <hans.verkuil@cisco.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <dineshk@xilinx.com>,
        <sandipk@xilinx.com>
Subject: Re: [v3,2/2] media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem
Message-ID: <20190213194539.GA11819@smtp.xilinx.com>
References: <1549025766-135037-3-git-send-email-vishal.sagar@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1549025766-135037-3-git-send-email-vishal.sagar@xilinx.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(136003)(346002)(376002)(2980300002)(199004)(189003)(45074003)(51914003)(6862004)(4326008)(107886003)(14444005)(50466002)(33656002)(229853002)(7416002)(446003)(305945005)(8676002)(6246003)(11346002)(106466001)(126002)(336012)(23676004)(9786002)(1076003)(76176011)(2906002)(36386004)(2486003)(186003)(8936002)(356004)(478600001)(426003)(106002)(47776003)(476003)(77096007)(486006)(76506005)(44832011)(81166006)(54906003)(57986006)(16586007)(63266004)(316002)(6636002)(58126008)(81156014)(26005)(18370500001)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR02MB2147;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
X-Microsoft-Exchange-Diagnostics: 1;BL2NAM02FT026;1:LirTRNYvdSzrgrDLRlzXZMMI/uZbDRMgdrX7wsNSQxUgCptAU3OGBuqDUXe5cdwMvIuJ9QvrK0KRhVeC0NGUa9K/YCg/vwbj8PX+g99QhLwpcPj8skHmuEfOqW6NJeGFi6LBy5AZrNXJMgNVoGCoCwpMT7LYAeTNQa3eYrUxxF4=
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1ba9c5e-f724-45b9-8e80-08d691ec0576
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(4608076)(4709027)(2017052603328)(7153060);SRVR:BL2PR02MB2147;
X-MS-TrafficTypeDiagnostic: BL2PR02MB2147:
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Exchange-Diagnostics: 1;BL2PR02MB2147;20:IvOr7uviogUqN5iefm5zO1TSL2gv+akY5V3VORBuYiBRlI8FcoStnvof6Xa97ac2Ml8CZQp26uLd/7Bite4OoSgt44fWhZiJQPrA0rLfyycI8nFSYt1g7IUfrk8o0Y/w/4r5asyR3bkaUA+2Xk6XfejZGEneF5E54E937e2pl6o9TfmFKIApMqpxFJni2gyDlz4Y4L29Z1COr7bZ32dBl1esJ3GqkHx9PMCx9UcuBkn2NHwZB5/dnYhHs0kHqm/YWROmOSsZBz/dJASyr1e5L57ThvPFuveQAXF7bT93wivWgDSXX+xaUu2C/DkWODBVcNGuSar3Tt3rkB620EH+f1GBqqk8JBi32okiEOPYo9UqlTHJnnLCtvHn1rlCzKDVndo2TQ9wzZAxfDd6jdhR+NdFz2r4ePYbZ9puMfUnpXSoqoZKCsfIaF8WRyjPFS2uxO7h/XRz5kP+DzMU33s63JuEda17CJWSw/hnPnB3J7D8n0nF5qOv4p4brvSs5LVC
X-Microsoft-Antispam-PRVS: <BL2PR02MB214702881DDFA86521F6F39FD6660@BL2PR02MB2147.namprd02.prod.outlook.com>
X-Forefront-PRVS: 094700CA91
X-Microsoft-Exchange-Diagnostics: =?utf-8?B?MTtCTDJQUjAyTUIyMTQ3OzIzOng0Q1NFUU10Wk41Yk1uMFNMRGZlYlNwK2dr?=
 =?utf-8?B?Q3ZNTkNJa1F1L1RMNlA3M0xXNHZRcXpxaFFZTFM1bU5KVDczaUNOdWEzWWor?=
 =?utf-8?B?RFYwdjU5aURLMVFLSXg4Q3NMSXpDL0s1aU1PaWtKYWcvRFBaT2YvQzBLVzda?=
 =?utf-8?B?NERNS25DM3RiTmN1M1o3aWoySFVIK1NuODg2YkhSbFdyUW53RGNJMXBwTnB0?=
 =?utf-8?B?bEYwaUdBRGZMTy85Q0pNcDdtQTNLcTl4bk5xOW1OTEpRNE96bnQyS05zdzQ3?=
 =?utf-8?B?VkxiZU5TRTNLckRYK2JkYVNwakxTZGE0ZDdpcWZhU0E1enpYSjlKMFlnOE5I?=
 =?utf-8?B?cXYvcmN4SXVBSFlxYW5JZi92VGdnVTIrcDFxWUZnTkY5dkZxTExQQVpVRWZz?=
 =?utf-8?B?aE90ajRUYTVRTmprc3B6UGFiVmppTXUvSGRrMTRLRjZPdlc0Wk1FYUE3L0Rq?=
 =?utf-8?B?aS9GTjZNSE5nUU1zcnZkZTJEWUZleVF6alArTEo3ZDRIcjc2VWI1TWNHWTFa?=
 =?utf-8?B?Y3dqMFBzNHBVZ2xiWXI2ZUxhWDNjNmIrRXMwQytuN1BVUW5jZWRXUG9ONUJD?=
 =?utf-8?B?SkluYzIvRGsxc2RhUElWM2x1NHlZZ0sySHVzV0F0cm9uZy9CY1lGdFlFOHp5?=
 =?utf-8?B?UlJGblVRR2dDZXJ4MlBxUHhsa1ZTcXRuZUc1cWNadFVnVmJxc0kxOTRucUV5?=
 =?utf-8?B?elMza1k3ZmxXQVRya1NXcFgrRUNHQ0E0OHlsYWxQaVY0eVBNaWRrcGpqZ3Fz?=
 =?utf-8?B?VitGYTEwMW12V0ZreWQ0bHZwOE1sVnMrU3ozQ2k3elB0UytHdmRydzdsUmZ6?=
 =?utf-8?B?bTUyWDNRdmZzdk1LeWh4M01zdHRqaGNyRklDdUU1Vk1VV09mYVZJZmJ0bU5a?=
 =?utf-8?B?R3c0Q1lkRFNCYTVtdHJKK3Z2NWZvYndxa2FPKzRyc2JlQUY5dUNtUzN5VGlK?=
 =?utf-8?B?OXlJSWxUM1hOSXBwektuU2krZi82MjhZNTdoSS9MUDhqbTJjb2paRDZOWlpD?=
 =?utf-8?B?ZEhNaGgrTVk0VUcxa2lYWmZFczZSSEZvT1RmUklRa1o1RFlPY0JQaS9FWFdK?=
 =?utf-8?B?VVY3dUlZQTZLRzhxZnFhMkh1VzZ6N2JmUEo1TXhTTTkzVERlQlByR25oYmE5?=
 =?utf-8?B?L2JBSUZyRFhBRnpXeEVVQkdFVGxGT2EreU4yaUFhV08xRlRTbVFmejFNZW9F?=
 =?utf-8?B?VzJ5Z2NuejZ4Tmo1U1dLdWZUb2tENG8zU0ZsWHhTclRGRWtRcEpTdDNtWk5h?=
 =?utf-8?B?ZFdia1F0Vy9UT1VjOTcwenl3TWtGdW1oUGtpc2hoTTVPSWk1RVhpb25jQ2U2?=
 =?utf-8?B?UmlxSWgyZUpBV1JpdkVGN0ZtVEFtZ2JRU2ZHNlMrekk4UG1LSm55RnNhVTFK?=
 =?utf-8?B?ZVJLS2lEQ2ZrODRRdEx4ckZ1WGh1czNMTkk1bjdVSUNOcFdlODhmTEwzTXRE?=
 =?utf-8?B?MUpRTC9JZWVSQktVTzlXMWI2SUtSMG1HbHhsdWJheXJENDVJR3lJc0hLMklD?=
 =?utf-8?B?OGdjc0c1Q2hldlhSYzNjRlVobDRWQ3QvckNKUlhYN1cxNThtNDE1MGNNQWRS?=
 =?utf-8?B?UXpoclkxTEhMWHpyWmJZRWJDdlVHMkMwZWYveTB5c28zV1dDL0MrMVUzTWVq?=
 =?utf-8?B?VUsrQXdsV1dldy9uVnFjUmpxMStCSHNZMk5hZDlZbVpkeUtQR0VtVlRPR2NM?=
 =?utf-8?Q?/YBp67eI82E43sqa6k=3D?=
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 4MRXBATxttGYBsDPIjIdFxwzEOz1roHxCkoXGAd9TvMwKmhBv8itj0QK4j/FrIqGyn4OZdRTzS10CmCTps/c7/kw0C0TUYIQN6+W5kUbcJtg9nxBW3z3AzPvelxxDHDGzTbLBTGEKFE8Ye5Lsp0Gj0wPduxXT/UpjBotizIRQV2femKVoEhqZ1sxIRbHV/h/NMO9Red77FhWzw7XV2lxZQXJZIV8XNeU9QZown+oVpJ0I9ruzi0xAaNhIkxU7bKPDbiWVl6J09v4Pd3o/P0dbMbDauTUWacrDRNWk5fDMLNh0YLnVDzNqKhiw3IQQfw01BuXlrM/Vy7i4NuMPgJiGJjlp51Pn2kcPnu4nyAn2yJM+NAa8sp5QU5iGZuIhGkR7UeNESLjokvShYFIOLgYcI961ts4Ckp+QBYZTwGDKR0=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2019 19:47:00.6392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ba9c5e-f724-45b9-8e80-08d691ec0576
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2PR02MB2147
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Vishal,

Thanks for the patch. Sorry for the delay.

On Fri, 2019-02-01 at 18:26:06 +0530, Vishal Sagar wrote:
> The Xilinx MIPI CSI-2 Rx Subsystem soft IP is used to capture images
> from MIPI CSI-2 camera sensors and output AXI4-Stream video data ready
> for image processing. Please refer to PG232 for details.
> 
> The driver is used to set the number of active lanes, if enabled
> in hardware. The CSI2 Rx controller filters out all packets except for
> the packets with data type fixed in hardware. RAW8 packets are always
> allowed to pass through.
> 
> It is also used to setup and handle interrupts and enable the core. It
> logs all the events in respective counters between streaming on and off.
> The generic short packets received are notified to application via
> v4l2_events.
> 
> The driver supports only the video format bridge enabled configuration.
> Some data types like YUV 422 10bpc, RAW16, RAW20 are supported when the
> CSI v2.0 feature is enabled in design. When the VCX feature is enabled,
> the maximum number of virtual channels becomes 16 from 4.
> 
> Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
> ---
> v3
> - Fixed comments given by Hyun.
> - Removed DPHY 200 MHz clock. This will be controlled by DPHY driver
> - Minor code formatting
> - en_csi_v20 and vfb members removed from struct and made local to dt parsing

[snip]

> +};
> +
> +/*
> + * struct xcsi2rxss_core - Core configuration CSI2 Rx Subsystem device structure
> + * @dev: Platform structure
> + * @iomem: Base address of subsystem
> + * @irq: requested irq number
> + * @enable_active_lanes: If number of active lanes can be modified
> + * @max_num_lanes: Maximum number of lanes present
> + * @datatype: Data type filter
> + * @bayer: bayer pattern
> + * @events: Structure to maintain event logs
> + * @vcx_events: Structure to maintain VCX event logs
> + * @en_vcx: If more than 4 VC are enabled
> + * @lite_aclk: AXI4-Lite interface clock
> + * @video_aclk: Video clock
> + */
> +struct xcsi2rxss_core {
> +	struct device *dev;
> +	void __iomem *iomem;
> +	int irq;

This doesn't have to be stored.

> +	bool enable_active_lanes;
> +	u32 max_num_lanes;
> +	u32 datatype;
> +	u32 bayer;
> +	struct xcsi2rxss_event *events;
> +	struct xcsi2rxss_event *vcx_events;
> +	bool en_vcx;
> +	struct clk *lite_aclk;
> +	struct clk *video_aclk;
> +};
> +
> +/**
> + * struct xcsi2rxss_state - CSI2 Rx Subsystem device structure
> + * @core: Core structure for MIPI CSI2 Rx Subsystem
> + * @subdev: The v4l2 subdev structure

[snip]

> +
> +/* Print event counters */
> +static void xcsi2rxss_log_counters(struct xcsi2rxss_state *state)
> +{
> +	struct xcsi2rxss_core *core = &state->core;
> +	int i;
> +
> +	for (i = 0; i < XCSI_NUM_EVENTS; i++) {
> +		if (core->events[i].counter > 0)

Does checkpatch warn if putting {} here, and

> +			dev_info(core->dev, "%s events: %d\n",
> +				 core->events[i].name,
> +				 core->events[i].counter);
> +	}
> +
> +	if (core->en_vcx)

here, and

> +		for (i = 0; i < XCSI_VCX_NUM_EVENTS; i++) {
> +			if (core->vcx_events[i].counter > 0)

here? But up to you.

> +				dev_info(core->dev,
> +					 "VC %d Frame %s err vcx events: %d\n",
> +					 (i / 2) + XCSI_VCX_START,
> +					 i & 1 ? "Sync" : "Level",
> +					 core->vcx_events[i].counter);
> +		}
> +}
> +
> +/**
> + * xcsi2rxss_log_status - Logs the status of the CSI-2 Receiver
> + * @sd: Pointer to V4L2 subdevice structure
> + *
> + * This function prints the current status of Xilinx MIPI CSI-2

[snip]

> +
> +/**
> + * xcsi2rxss_s_ctrl - This is used to set the Xilinx MIPI CSI-2 V4L2 controls
> + * @ctrl: V4L2 control to be set
> + *
> + * This function is used to set the V4L2 controls for the Xilinx MIPI
> + * CSI-2 Rx Subsystem. It is used to set the active lanes in the system.
> + * The event counters can be reset.
> + *
> + * Return: 0 on success, errors otherwise
> + */
> +static int xcsi2rxss_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct xcsi2rxss_state *xcsi2rxss =
> +		container_of(ctrl->handler, struct xcsi2rxss_state,
> +			     ctrl_handler);
> +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> +	int ret = 0;
> +
> +	mutex_lock(&xcsi2rxss->lock);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_XILINX_MIPICSISS_ACT_LANES:
> +		/*
> +		 * This will be called only when "Enable Active Lanes" parameter
> +		 * is set in design
> +		 */
> +		if (core->enable_active_lanes) {
> +			u32 active_lanes;
> +
> +			xcsi2rxss_clr_and_set(core, XCSI_PCR_OFFSET,
> +					      XCSI_PCR_ACTLANES_MASK,
> +					      ctrl->val - 1);
> +			/*
> +			 * This delay is to allow the value to reflect as write
> +			 * and read paths are different.
> +			 */
> +			udelay(1);
> +			active_lanes = xcsi2rxss_read(core, XCSI_PCR_OFFSET);
> +			active_lanes &= XCSI_PCR_ACTLANES_MASK;
> +			active_lanes++;
> +			if (active_lanes != ctrl->val)
> +				dev_info(core->dev, "RxByteClkHS absent\n");
> +			dev_dbg(core->dev, "active lanes = %d\n", ctrl->val);
> +		} else {
> +			ret = -EINVAL;
> +		}
> +		break;
> +	case V4L2_CID_XILINX_MIPICSISS_RESET_COUNTERS:
> +		xcsi2rxss_reset_event_counters(xcsi2rxss);
> +		break;
> +	default:

-EINVAL?

> +		break;
> +	}
> +
> +	mutex_unlock(&xcsi2rxss->lock);
> +
> +	return ret;
> +}
> +

[snip]

> +
> +static void xcsi2rxss_clk_disable(struct xcsi2rxss_core *core)
> +{
> +	clk_disable_unprepare(core->video_aclk);
> +	clk_disable_unprepare(core->lite_aclk);
> +}
> +
> +static int xcsi2rxss_parse_of(struct xcsi2rxss_state *xcsi2rxss)
> +{
> +	struct xcsi2rxss_core *core = &xcsi2rxss->core;
> +	struct device_node *node = xcsi2rxss->core.dev->of_node;
> +	struct device_node *ports = NULL;
> +	struct device_node *port = NULL;
> +	unsigned int nports;
> +	bool en_csi_v20, vfb;
> +	int ret;
> +
> +	en_csi_v20 = of_property_read_bool(node, "xlnx,en-csi-v2-0");
> +	if (en_csi_v20) {
> +		core->en_vcx = of_property_read_bool(node, "xlnx,en-vcx");
> +		dev_dbg(core->dev, "vcx %s", core->en_vcx ? "enabled" :
> +			"disabled");
> +	}
> +
> +	dev_dbg(core->dev, "en_csi_v20 %s", en_csi_v20 ? "enabled" :
> +		"disabled");

Would it be better to have these options visible with log?
It can be printed as a part of final banner in probe. Up to you.

> +
> +	core->enable_active_lanes =
> +		of_property_read_bool(node, "xlnx,en-active-lanes");
> +	dev_dbg(core->dev, "Enable active lanes property = %s\n",
> +		core->enable_active_lanes ? "Present" : "Absent");
> +
> +	ret = of_property_read_u32(node, "xlnx,csi-pxl-format",
> +				   &core->datatype);
> +	if (ret < 0) {
> +		dev_err(core->dev, "missing xlnx,csi-pxl-format property\n");
> +		return ret;
> +	}
> +
> +	switch (core->datatype) {
> +	case XCSI_DT_YUV4228B:
> +	case XCSI_DT_RGB444:
> +	case XCSI_DT_RGB555:
> +	case XCSI_DT_RGB565:
> +	case XCSI_DT_RGB666:
> +	case XCSI_DT_RGB888:
> +	case XCSI_DT_RAW6:
> +	case XCSI_DT_RAW7:
> +	case XCSI_DT_RAW8:
> +	case XCSI_DT_RAW10:
> +	case XCSI_DT_RAW12:
> +	case XCSI_DT_RAW14:
> +		break;
> +	case XCSI_DT_YUV42210B:
> +	case XCSI_DT_RAW16:
> +	case XCSI_DT_RAW20:
> +		if (!en_csi_v20) {
> +			ret = -EINVAL;
> +			dev_dbg(core->dev, "enable csi v2 for this pixel format");
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +	if (ret < 0) {
> +		dev_err(core->dev, "invalid csi-pxl-format property!\n");
> +		return ret;
> +	}
> +
> +	dev_dbg(core->dev, "pixel format set as 0x%x\n", core->datatype);
> +
> +	vfb = of_property_read_bool(node, "xlnx,vfb");
> +	dev_dbg(core->dev, "Video Format Bridge property = %s\n",
> +		vfb ? "Present" : "Absent");

I'd collect all these print in one print or one location. But up to you.

> +
> +	if (!vfb) {
> +		dev_err(core->dev, "failed as VFB is disabled!\n");
> +		return -EINVAL;
> +	}

[snip]

> +	/* Register interrupt handler */
> +	core->irq = irq_of_parse_and_map(node, 0);
> +	ret = devm_request_irq(core->dev, core->irq, xcsi2rxss_irq_handler,
> +			       IRQF_SHARED, "xilinx-csi2rxss", xcsi2rxss);
> +	if (ret) {
> +		dev_err(core->dev, "Err = %d Interrupt handler reg failed!\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int xcsi2rxss_probe(struct platform_device *pdev)
> +{
> +	struct v4l2_subdev *subdev;
> +	struct xcsi2rxss_state *xcsi2rxss;
> +	struct xcsi2rxss_core *core;
> +	struct resource *res;
> +	int ret, num_ctrls, i;
> +
> +	xcsi2rxss = devm_kzalloc(&pdev->dev, sizeof(*xcsi2rxss), GFP_KERNEL);
> +	if (!xcsi2rxss)
> +		return -ENOMEM;
> +
> +	core = &xcsi2rxss->core;
> +	core->dev = &pdev->dev;
> +
> +	mutex_init(&xcsi2rxss->lock);
> +
> +	ret = xcsi2rxss_parse_of(xcsi2rxss);
> +	if (ret < 0)
> +		return ret;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	core->iomem = devm_ioremap_resource(core->dev, res);
> +	if (IS_ERR(core->iomem))
> +		return PTR_ERR(core->iomem);
> +
> +	ret = xcsi2rxss_clk_get(core);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = xcsi2rxss_clk_enable(core);
> +	if (ret < 0)
> +		return ret;

Not sure if I mentioned, please consider having these with
stream on / off later.

I only have minor comments, and it looks fine to me. Please take a look at
those comments, then

	Reviewed-by: Hyun Kwon <hyun.kwon@xilinx.com>

Thanks,
-hyun

