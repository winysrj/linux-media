Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:33982 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751207AbdBWVlv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 16:41:51 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Kamil Debski <kamil@wypas.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [media] s5p-cec: strange clk enabling pattern
Date: Fri, 24 Feb 2017 00:41:38 +0300
Message-Id: <1487886098-20557-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The s5p-cec driver has a few places that touch hdmicec clk:

static int s5p_cec_probe(struct platform_device *pdev)
{
	...
	cec->clk = devm_clk_get(dev, "hdmicec");
	if (IS_ERR(cec->clk))
		return PTR_ERR(cec->clk);
	...
}

static int __maybe_unused s5p_cec_runtime_suspend(struct device *dev)
{
	struct s5p_cec_dev *cec = dev_get_drvdata(dev);

	clk_disable_unprepare(cec->clk);
	return 0;
}

static int __maybe_unused s5p_cec_runtime_resume(struct device *dev)
{
	struct s5p_cec_dev *cec = dev_get_drvdata(dev);
	int ret;

	ret = clk_prepare_enable(cec->clk);
	if (ret < 0)
		return ret;
	return 0;
}

Is it ok to enable/disable clock in rusume/suspend only?
Or have I missed anything?

--
Thank you,
Alexey Khoroshilov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org
