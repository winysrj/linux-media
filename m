Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBF7C43612
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 19:24:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EAC720663
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 19:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfAITYt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 14:24:49 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:35076 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbfAITYt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 14:24:49 -0500
Received: from marcel-macpro.fritz.box (p4FF9FD60.dip0.t-ipconnect.de [79.249.253.96])
        by mail.holtmann.org (Postfix) with ESMTPSA id 78C94CF357;
        Wed,  9 Jan 2019 20:32:31 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [PATCH 12/14] media: wl128x-radio: move from TI_ST to hci_ll
 driver
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20190109181156.yamhult6bpwkhx74@earth.universe>
Date:   Wed, 9 Jan 2019 20:24:46 +0100
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0C9AD246-B511-4E59-888F-47EAB034D4BF@holtmann.org>
References: <20181221011752.25627-1-sre@kernel.org>
 <20181221011752.25627-13-sre@kernel.org>
 <C85D80C9-2B00-4161-B934-9D70E2B173D0@holtmann.org>
 <20190109181156.yamhult6bpwkhx74@earth.universe>
To:     Sebastian Reichel <sre@kernel.org>
X-Mailer: Apple Mail (2.3445.102.3)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sebastian,

>>> +static int ll_register_fm(struct ll_device *lldev)
>>> +{
>>> +	struct device *dev = &lldev->serdev->dev;
>>> +	int err;
>>> +
>>> +	if (!of_device_is_compatible(dev->of_node, "ti,wl1281-st") &&
>>> +	    !of_device_is_compatible(dev->of_node, "ti,wl1283-st") &&
>>> +	    !of_device_is_compatible(dev->of_node, "ti,wl1285-st"))
>>> +		return -ENODEV;
>> 
>> do we really want to hardcode this here? Isn't there some HCI
>> vendor command or some better DT description that we can use to
>> decide when to register this platform device.
> 
> I don't know if there is some way to identify the availability
> based on some HCI vendor command. The public documentation from
> the WiLink chips is pretty bad.

can we have some boolean property in the DT file then instead of hardcoding this in the driver.

> 
>>> +	lldev->fmdev = platform_device_register_data(dev, "wl128x-fm",
>>> +		PLATFORM_DEVID_AUTO, NULL, 0);
>> 
>> Fix the indentation please to following networking coding style.
> 
> Ok.
> 
> [...]
> 
>>> +static int ll_recv_radio(struct hci_dev *hdev, struct sk_buff *skb)
>>> +{
>>> +	struct hci_uart *hu = hci_get_drvdata(hdev);
>>> +	struct serdev_device *serdev = hu->serdev;
>>> +	struct ll_device *lldev = serdev_device_get_drvdata(serdev);
>>> +
>>> +	if (!lldev->fm_handler) {
>>> +		kfree_skb(skb);
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	/* Prepend skb with frame type */
>>> +	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
>>> +
>>> +	lldev->fm_handler(lldev->fm_drvdata, skb);
>> 
>> So I have no idea why we bother adding the frame type here. What
>> is the purpose. I think this is useless and we better fix the
>> radio driver if that is what is expected.
> 
> That should be possible. I will change this before sending another
> revision.
> 
>>> +	return 0;
>>> +}
> 
> [...]
> 
>>> +int hci_ti_fm_send(struct device *dev, struct sk_buff *skb)
>>> +{
>>> +	struct serdev_device *serdev = to_serdev_device(dev);
>>> +	struct ll_device *lldev = serdev_device_get_drvdata(serdev);
>>> +	struct hci_uart *hu = &lldev->hu;
>>> +	int ret;
>>> +
>>> +	hci_skb_pkt_type(skb) = HCILL_FM_RADIO;
>>> +	ret = ll_enqueue_prefixed(hu, skb);
>> 
>> This is the same as above, lets have the radio driver not add this
>> H:4 protocol type in the first place. It is really pointless that
>> this driver tries to hack around it.
> 
> Yes, obviously both paths should follow the same logic.
> 
> [...]
> 
>>> diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
>>> index f2293028ab9d..a9de5654b0cd 100644
>>> --- a/include/linux/ti_wilink_st.h
>>> +++ b/include/linux/ti_wilink_st.h
>>> @@ -86,6 +86,8 @@ struct st_proto_s {
>>> extern long st_register(struct st_proto_s *);
>>> extern long st_unregister(struct st_proto_s *);
>>> 
>>> +void hci_ti_set_fm_handler(struct device *dev, void (*recv_handler) (void *, struct sk_buff *), void *drvdata);
>>> +int hci_ti_fm_send(struct device *dev, struct sk_buff *skb);
>> 
>> This really needs to be put somewhere else if we are removing the
>> TI Wilink driver. This header file has to be removed as well.
> 
> That header is already being used by the hci_ll driver (before this
> patch) for some packet structures. I removed all WiLink specific
> things in the patch removing the TI WiLink driver and kept it
> otherwise.

We need to move everything from ti_wilink_st.h that is used in hci_ll.c into that file.

> 
>> I wonder really if we are not better having the Bluetooth HCI core
>> provide an abstraction for a vendor channel. So that the HCI
>> packets actually can flow through HCI monitor and be recorded via
>> btmon. This would also mean that the driver could do something
>> like hci_vnd_chan_add() and hci_vnd_chan_del() and use a struct
>> hci_vnd_chan for callback handler hci_vnd_chan_send() functions.
> 
> Was this question directed to me? I trust your decision how this
> should be implemented. I'm missing the big picture from other BT
> devices ;)
> 
> If I understood you correctly the suggestion is, that the TI BT
> driver uses hci_recv_frame() for packet type 0x08 (LL_RECV_FM_RADIO).
> Then the FM driver can call hci_vnd_chan_add() in its probe function
> and hci_vnd_chan_del() in its remove function to register the receive
> hook? Also the dump_tx_skb_data()/dump_rx_skb_data() could be
> removed, since btmon can be used to see the packets? Sounds very
> nice to me.
> 
>> On a side note, what is the protocol the TI FM radio is using
>> anyway? Is that anywhere documented except the driver itself? Are
>> they using HCI commands as well?
> 
> AFAIK there is no public documentation for the TI WiLink chips. At
> least my only information source are the existing drivers. The
> driver protocol can be seen in drivers/media/radio/wl128x/fmdrv_common.h:
> 
> struct fm_cmd_msg_hdr {
> 	__u8 hdr;		/* Logical Channel-8 */
> 	__u8 len;		/* Number of bytes follows */
> 	__u8 op;		/* FM Opcode */
> 	__u8 rd_wr;		/* Read/Write command */
> 	__u8 dlen;		/* Length of payload */
> } __attribute__ ((packed));
> 
> struct fm_event_msg_hdr {
> 	__u8 header;		/* Logical Channel-8 */
> 	__u8 len;		/* Number of bytes follows */
> 	__u8 status;		/* Event status */
> 	__u8 num_fm_hci_cmds;	/* Number of pkts the host allowed to send */
> 	__u8 op;		/* FM Opcode */
> 	__u8 rd_wr;		/* Read/Write command */
> 	__u8 dlen;		/* Length of payload */
> } __attribute__ ((packed));

This is really a custom protocol (even if it kinda modeled after HCI commands/events) and it be really better the core allows to register skb_pkt_type() vendor channels so it just feeds this back into the driver. We need a bit of btmon mapping for this, but that shouldn’t be that hard.

> Apart from the Bluetooth and FM part, the chips also support GPS
> (packet type 0x9). The GPS feature is not used on Droid 4 stock
> rom and seems to carry some TI specific protocol instead of NMEA.
> Here is an old submission for this driver:
> http://lkml.iu.edu/hypermail/linux/kernel/1005.0/00918.html
> 
> (I don't plan to work on the GPS part, but it provides some more
> details about the WiLink chips protocol)

We do have a GNSS subsystem now and could just as easily hook this up.

Regards

Marcel

