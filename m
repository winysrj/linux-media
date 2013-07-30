Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:28829 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3G3MjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 08:39:08 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQR008YU1SA8K20@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Jul 2013 08:39:07 -0400 (EDT)
Date: Tue, 30 Jul 2013 09:39:02 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QsOlcmQ=?= Eirik Winther <bwinther@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 FINAL 2/6] qv4l2: add hotkeys for common operations
Message-id: <20130730093902.51d196b5@samsung.com>
In-reply-to: <1724e63348e1dedd4b740bb37ec1dface271a00a.1375172029.git.bwinther@cisco.com>
References: <1375172124-14439-1-git-send-email-bwinther@cisco.com>
 <1724e63348e1dedd4b740bb37ec1dface271a00a.1375172029.git.bwinther@cisco.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bård/Hans,

Em Tue, 30 Jul 2013 10:15:20 +0200
Bård Eirik Winther <bwinther@cisco.com> escreveu:

> CTRL + V : When main window is selected start capture.
>            This gives an option other than the button to start recording,
>            as this is a frequent operation when using the utility.
> CTRL + W : When CaptureWin is selected close capture window
>            It makes it easier to deal with high resolutions video on
>            small screen, especially when the window close button may
>            be outside the monitor when repositioning the window.

It would be great if you could also add some documentation for qv4l2,
adding there the supported hot keys.

IMO, the better is to write it as a man page. If you need an example,
you could take a look at utils/keytable/ir-keytable.1.

At the building system, all that it is needed is to add something like
what's there at utils/keytable/Makefile.am:
	man_MANS = ir-keytable.1

Thanks,
Mauro

> 
> Signed-off-by: Bård Eirik Winther <bwinther@cisco.com>
> ---
>  utils/qv4l2/capture-win.cpp | 8 ++++++++
>  utils/qv4l2/capture-win.h   | 4 +++-
>  utils/qv4l2/qv4l2.cpp       | 1 +
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/utils/qv4l2/capture-win.cpp b/utils/qv4l2/capture-win.cpp
> index 6798252..a94c73d 100644
> --- a/utils/qv4l2/capture-win.cpp
> +++ b/utils/qv4l2/capture-win.cpp
> @@ -35,6 +35,14 @@ CaptureWin::CaptureWin()
>  
>  	vbox->addWidget(m_label);
>  	vbox->addWidget(m_msg);
> +
> +	hotkeyClose = new QShortcut(Qt::CTRL+Qt::Key_W, this);
> +	QObject::connect(hotkeyClose, SIGNAL(activated()), this, SLOT(close()));
> +}
> +
> +CaptureWin::~CaptureWin()
> +{
> +	delete hotkeyClose;
>  }
>  
>  void CaptureWin::setImage(const QImage &image, const QString &status)
> diff --git a/utils/qv4l2/capture-win.h b/utils/qv4l2/capture-win.h
> index e861b12..4115d56 100644
> --- a/utils/qv4l2/capture-win.h
> +++ b/utils/qv4l2/capture-win.h
> @@ -21,6 +21,7 @@
>  #define CAPTURE_WIN_H
>  
>  #include <QWidget>
> +#include <QShortcut>
>  #include <sys/time.h>
>  
>  class QImage;
> @@ -32,7 +33,7 @@ class CaptureWin : public QWidget
>  
>  public:
>  	CaptureWin();
> -	virtual ~CaptureWin() {}
> +	~CaptureWin();
>  
>  	void setImage(const QImage &image, const QString &status);
>  
> @@ -45,6 +46,7 @@ signals:
>  private:
>  	QLabel *m_label;
>  	QLabel *m_msg;
> +	QShortcut *hotkeyClose;
>  };
>  
>  #endif
> diff --git a/utils/qv4l2/qv4l2.cpp b/utils/qv4l2/qv4l2.cpp
> index a8fcc65..bb1d84f 100644
> --- a/utils/qv4l2/qv4l2.cpp
> +++ b/utils/qv4l2/qv4l2.cpp
> @@ -78,6 +78,7 @@ ApplicationWindow::ApplicationWindow() :
>  	m_capStartAct->setStatusTip("Start capturing");
>  	m_capStartAct->setCheckable(true);
>  	m_capStartAct->setDisabled(true);
> +	m_capStartAct->setShortcut(Qt::CTRL+Qt::Key_V);
>  	connect(m_capStartAct, SIGNAL(toggled(bool)), this, SLOT(capStart(bool)));
>  
>  	m_snapshotAct = new QAction(QIcon(":/snapshot.png"), "&Make Snapshot", this);


-- 

Cheers,
Mauro
