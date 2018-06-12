Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:47170 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754046AbeFLJId (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 05:08:33 -0400
Date: Tue, 12 Jun 2018 12:07:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Colin King <colin.king@canonical.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-media@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] cx18: remove redundant zero check on retval
Message-ID: <20180612090745.2k6jmljl73bwj6lm@mwanda>
References: <20180611151045.22535-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180611151045.22535-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You accidentally committed several changes...

regards,
dan carpenter

On Mon, Jun 11, 2018 at 04:10:45PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The check for a zero retval is redundant as all paths that lead to
> this point have set retval to an error return value that is non-zero.
> Remove the redundant check.
> 
> Detected by CoverityScan, CID#102589 ("Logically dead code")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/firewire/firedtv-fw.c  | 3 +++
>  drivers/media/pci/cx18/cx18-driver.c | 2 --
>  drivers/regulator/vctrl-regulator.c  | 2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/firewire/firedtv-fw.c b/drivers/media/firewire/firedtv-fw.c
> index 92f4112d2e37..eed55be21836 100644
> --- a/drivers/media/firewire/firedtv-fw.c
> +++ b/drivers/media/firewire/firedtv-fw.c
> @@ -271,6 +271,9 @@ static int node_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
>  
>  	name_len = fw_csr_string(unit->directory, CSR_MODEL,
>  				 name, sizeof(name));
> +	if (name_len < 0)
> +		return name_len;
> +
>  	for (i = ARRAY_SIZE(model_names); --i; )
>  		if (strlen(model_names[i]) <= name_len &&
>  		    strncmp(name, model_names[i], name_len) == 0)
> diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
> index 8f314ca320c7..0c389a3fb4e5 100644
> --- a/drivers/media/pci/cx18/cx18-driver.c
> +++ b/drivers/media/pci/cx18/cx18-driver.c
> @@ -1134,8 +1134,6 @@ static int cx18_probe(struct pci_dev *pci_dev,
>  free_workqueues:
>  	destroy_workqueue(cx->in_work_queue);
>  err:
> -	if (retval == 0)
> -		retval = -ENODEV;
>  	CX18_ERR("Error %d on initialization\n", retval);
>  
>  	v4l2_device_unregister(&cx->v4l2_dev);
> diff --git a/drivers/regulator/vctrl-regulator.c b/drivers/regulator/vctrl-regulator.c
> index 78de002037c7..044e5a5ca163 100644
> --- a/drivers/regulator/vctrl-regulator.c
> +++ b/drivers/regulator/vctrl-regulator.c
> @@ -340,7 +340,7 @@ static int vctrl_init_vtable(struct platform_device *pdev)
>  		}
>  	}
>  
> -	if (rdesc->n_voltages == 0) {
> +	if (rdesc->n_voltages <= 0) {
>  		dev_err(&pdev->dev, "invalid configuration\n");
>  		return -EINVAL;
>  	}
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
