Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:61350 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759789AbZLOK5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 05:57:39 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1092419eyd.19
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2009 02:57:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21846845.2414981260873072666.JavaMail.defaultUser@defaultHost>
References: <21846845.2414981260873072666.JavaMail.defaultUser@defaultHost>
From: ALi <osatien@gmail.com>
Date: Tue, 15 Dec 2009 11:57:17 +0100
Message-ID: <431ff28c0912150257n4155816frc49bd64e87cb839e@mail.gmail.com>
Subject: Re: [linux-dvb] capture emm and ecm stream
To: linux-media@vger.kernel.org,
	"lucaberto@libero.it" <lucaberto@libero.it>
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

when i did my first emm decoder (;->) i took the source code from
dvbsnoop and it worked for me ..... can you try it?

can you try first dvbsnoop with the parameters you want?

On Tue, Dec 15, 2009 at 11:31 AM, lucaberto@libero.it
<lucaberto@libero.it> wrote:
> hello i have write i little c program for test :
> here is the program:
>
> #include
> <stdio.h>
> #include </usr/include/linux/dvb/frontend.h>
> #include <stdlib.h>
>
> #include <stdint.h>
> #include <ctype.h>
> #include <sys/ioctl.h>
> #include
> <sys/poll.h>
> #include <unistd.h>
> #include <error.h>
> #include <errno.h>
> #include
> <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> #include <time.h>
>
> #include <unistd.h>
> #include <linux/dvb/dmx.h>
> #include <linux/dvb/frontend.h>
>
> #include <linux/dvb/dmx.h>
>
> #define MIA "/dev/dvb/adapter0/frontend0"
> #define
> MD "/dev/dvb/adapter0/demux0"
> //#define DVR "/dev/dvb/adapter0/dvr0"
> #define
> DVR_FILE "/home/lucak904/Scrivania/Luca/prog_c/sat/mio.dat"
> #define BUFFY
> (188*20)
>
> main()
>
> {
>    struct dvb_frontend_info luca;
>    struct
> dvb_frontend_parameters parametri;
>    struct dvb_frontend_parameters luca2;
>
>    struct dmx_pes_filter_params filtri;
>
>    parametri.frequency = 1197700;
>
>    parametri.inversion = INVERSION_AUTO;
>    parametri.u.qpsk.symbol_rate =
> 2750000;
>    parametri.u.qpsk.fec_inner   = FEC_AUTO;
>
>
>    fe_status_t status;
>
>    int fd, min, max,chiudo_fd, chiudo_md, chiudo_dvr ,stato, pp, freq,
> ritorno, sy_rate, tt, md,fec_inn, inv, dvr, dvr_out,len;
>    uint8_t buf
> [BUFFY];
>
>
>        if((fd = open(MIA,O_RDWR)) < 0){
>                perror("FRONTEND
> DEVICE: ");
>                return -1;
>    }
>        if (ioctl(fd, FE_SET_FRONTEND,
> &parametri) < 0){
>                perror("QPSK TUNE: ");
>                return
> -1;
>    }
>    if (ioctl(fd, FE_GET_FRONTEND ,&luca2) <0){
>                perror
> ("GET_INFO: ");
>                return -1;
>    }
>
>        printf("\nfreq :%d", luca2.
> frequency);
>    printf("\nsimbol_rate : %d", luca2.u.qpsk.symbol_rate);
>
> printf("\ninversion : %d", luca2.inversion);
>    printf("\nfec : %d", luca2.u.
> qpsk.fec_inner);
>
>
>    if (ioctl(fd, FE_GET_INFO  ,&luca) <0){
>
> perror("GET_INFO: ");
>                return -1;
>    }
>
>        printf("\nfreq min:%
> d", luca.frequency_min);
>        printf("\nfreq max:%d", luca.frequency_max);
>
>        if
> (ioctl(fd, FE_READ_STATUS  ,&status) <0){
>                perror
> ("FE_READ_STATUS: ");
>                return -1;
>    }
>
>    // apro il demux
>
>
>    printf("\nstato :%d", status);
>    if((md = open(MD,O_RDWR|O_NONBLOCK)) < 0)
> {
>                perror("DEMUX DEVICE: ");
>                return -1;
>    }
>
>
>    //setto il demux
>
>    filtri.pid = 1296;
>    filtri.input =
> DMX_IN_FRONTEND;
>    filtri.output = DMX_OUT_TAP;
>    filtri.pes_type =
> DMX_PES_OTHER;
>    filtri.flags = DMX_IMMEDIATE_START;
>    if (ioctl(md,
> DMX_SET_PES_FILTER, &filtri) < 0) {
>            perror("DEMUX DEVICE: ");
>
>            return -1;
>    }
>
>    //apro il dvr
>
>    //if ((dvr = open(DVR,
> O_RDONLY|O_NONBLOCK)) < 0) {
>      //      perror("DVR DEVICE : ");
> //
> /    return -1;
>  //  }
>
>    if ((dvr_out = open
> ("/home/lucak904/Scrivania/Luca/prog_c/sat/prova_scar.txt", O_WRONLY)) < 0) {
>
>            perror(" DVR FILE : ");
>            return -1;
>    }
>
>
>    if((len
> = read(md,buf, BUFFY)) < 0){
>        perror("non leggo");
>    }
>    else{
>
>        write(dvr_out,buf,len);
>
>    }
>
>    chiudo_fd = close(fd);
>
> chiudo_md = close(md);
>    //chiudo_dvr = close(dvr);
> }
>
> It is just a test
>
> every time i get Resource temporarily unavailable
> For my understanding it means
> that nothing is readed from demux device, wath is wrong , the pid and frequency
> are ok the SNR is more than 70%
>
> Thanks
>
> Luca
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
