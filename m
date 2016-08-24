Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:59624 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751774AbcHXKrZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 06:47:25 -0400
Subject: Re: [PATCH] cec tools: exit if device is disconnected
To: Johan Fjeldtvedt <jaffe1@gmail.com>, linux-media@vger.kernel.org
References: <1472034678-13813-1-git-send-email-jaffe1@gmail.com>
 <1472034678-13813-2-git-send-email-jaffe1@gmail.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <57BD7B3A.4080500@cisco.com>
Date: Wed, 24 Aug 2016 12:47:22 +0200
MIME-Version: 1.0
In-Reply-To: <1472034678-13813-2-git-send-email-jaffe1@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/24/16 12:31, Johan Fjeldtvedt wrote:
> If the CEC device is disconnected, ioctl will return ENODEV. This is
> checked for in cec-ctl (when monitoring), cec-follower and
> cec-compliance, to make these exit when the CEC device disappears.
> 
> Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
> ---
>  utils/cec-compliance/cec-compliance.h |  9 +++++++--
>  utils/cec-ctl/cec-ctl.cpp             |  7 ++++++-
>  utils/cec-follower/cec-processing.cpp | 14 ++++++++++++--
>  3 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/utils/cec-compliance/cec-compliance.h b/utils/cec-compliance/cec-compliance.h
> index cb236fd..6b180c1 100644
> --- a/utils/cec-compliance/cec-compliance.h
> +++ b/utils/cec-compliance/cec-compliance.h
> @@ -334,10 +334,15 @@ static inline bool transmit_timeout(struct node *node, struct cec_msg *msg,
>  				    unsigned timeout = 2000)
>  {
>  	struct cec_msg original_msg = *msg;
> +	int res;
>  
>  	msg->timeout = timeout;
> -	if (doioctl(node, CEC_TRANSMIT, msg) ||
> -	    !(msg->tx_status & CEC_TX_STATUS_OK))
> +	res = doioctl(node, CEC_TRANSMIT, msg);
> +	if (res == ENODEV) {
> +		printf("No device.\n");

I think that "Device was disconnected." would be a better text to use. It's a bit more
descriptive.

Regards,

	Hans

> +		exit(1);
> +	}
> +	if (res || !(msg->tx_status & CEC_TX_STATUS_OK))
>  		return false;
>  
>  	if (((msg->rx_status & CEC_RX_STATUS_OK) || (msg->rx_status & CEC_RX_STATUS_FEATURE_ABORT))
> diff --git a/utils/cec-ctl/cec-ctl.cpp b/utils/cec-ctl/cec-ctl.cpp
> index 2d0d9e5..10efcbd 100644
> --- a/utils/cec-ctl/cec-ctl.cpp
> +++ b/utils/cec-ctl/cec-ctl.cpp
> @@ -1945,7 +1945,12 @@ skip_la:
>  				struct cec_msg msg = { };
>  				__u8 from, to;
>  
> -				if (doioctl(&node, CEC_RECEIVE, &msg))
> +				res = doioctl(&node, CEC_RECEIVE, &msg);
> +				if (res == ENODEV) {
> +					printf("No device.\n");
> +					break;
> +				}
> +				if (res)
>  					continue;
>  
>  				from = cec_msg_initiator(&msg);
> diff --git a/utils/cec-follower/cec-processing.cpp b/utils/cec-follower/cec-processing.cpp
> index 34d65e4..bbe80c5 100644
> --- a/utils/cec-follower/cec-processing.cpp
> +++ b/utils/cec-follower/cec-processing.cpp
> @@ -979,7 +979,12 @@ void testProcessing(struct node *node)
>  		if (FD_ISSET(fd, &ex_fds)) {
>  			struct cec_event ev;
>  
> -			if (doioctl(node, CEC_DQEVENT, &ev))
> +			res = doioctl(node, CEC_DQEVENT, &ev);
> +			if (res == ENODEV) {
> +				printf("No device.\n");
> +				break;
> +			}
> +			if (res)
>  				continue;
>  			log_event(ev);
>  			if (ev.event == CEC_EVENT_STATE_CHANGE) {
> @@ -995,7 +1000,12 @@ void testProcessing(struct node *node)
>  		if (FD_ISSET(fd, &rd_fds)) {
>  			struct cec_msg msg = { };
>  
> -			if (doioctl(node, CEC_RECEIVE, &msg))
> +			res = doioctl(node, CEC_RECEIVE, &msg);
> +			if (res == ENODEV) {
> +				printf("No device.\n");
> +				break;
> +			}
> +			if (res)
>  				continue;
>  
>  			__u8 from = cec_msg_initiator(&msg);
> 
