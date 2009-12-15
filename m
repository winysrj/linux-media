Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cp-out2.libero.it ([212.52.84.102])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <lucaberto@libero.it>) id 1NKUh3-0005Ds-DR
	for linux-dvb@linuxtv.org; Tue, 15 Dec 2009 11:31:50 +0100
Received: from wmail43 (172.31.0.232) by cp-out2.libero.it (8.5.107)
	id 4B266D0F000A11FF for linux-dvb@linuxtv.org;
	Tue, 15 Dec 2009 11:31:12 +0100
Message-ID: <21846845.2414981260873072666.JavaMail.defaultUser@defaultHost>
Date: Tue, 15 Dec 2009 11:31:12 +0100 (CET)
From: "lucaberto@libero.it" <lucaberto@libero.it>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] capture emm and ecm stream
Reply-To: linux-media@vger.kernel.org,
	"lucaberto@libero.it" <lucaberto@libero.it>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

hello i have write i little c program for test :
here is the program:

#include 
<stdio.h>
#include </usr/include/linux/dvb/frontend.h>
#include <stdlib.h>

#include <stdint.h>
#include <ctype.h>
#include <sys/ioctl.h>
#include 
<sys/poll.h>
#include <unistd.h>
#include <error.h>
#include <errno.h>
#include 
<sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>

#include <unistd.h>
#include <linux/dvb/dmx.h>
#include <linux/dvb/frontend.h>

#include <linux/dvb/dmx.h>

#define MIA "/dev/dvb/adapter0/frontend0"
#define 
MD "/dev/dvb/adapter0/demux0"
//#define DVR "/dev/dvb/adapter0/dvr0"
#define 
DVR_FILE "/home/lucak904/Scrivania/Luca/prog_c/sat/mio.dat"
#define BUFFY 
(188*20)

main()

{
    struct dvb_frontend_info luca;
    struct 
dvb_frontend_parameters parametri;
    struct dvb_frontend_parameters luca2;

    struct dmx_pes_filter_params filtri;

    parametri.frequency = 1197700;

    parametri.inversion = INVERSION_AUTO;
    parametri.u.qpsk.symbol_rate = 
2750000;
    parametri.u.qpsk.fec_inner   = FEC_AUTO;


    fe_status_t status;

    int fd, min, max,chiudo_fd, chiudo_md, chiudo_dvr ,stato, pp, freq, 
ritorno, sy_rate, tt, md,fec_inn, inv, dvr, dvr_out,len;
    uint8_t buf
[BUFFY];


	if((fd = open(MIA,O_RDWR)) < 0){
                perror("FRONTEND 
DEVICE: ");
                return -1;
    }
	if (ioctl(fd, FE_SET_FRONTEND, 
&parametri) < 0){
                perror("QPSK TUNE: ");
                return 
-1;
    }
    if (ioctl(fd, FE_GET_FRONTEND ,&luca2) <0){
                perror
("GET_INFO: ");
                return -1;
    }

	printf("\nfreq :%d", luca2.
frequency);
    printf("\nsimbol_rate : %d", luca2.u.qpsk.symbol_rate);
    
printf("\ninversion : %d", luca2.inversion);
    printf("\nfec : %d", luca2.u.
qpsk.fec_inner);


    if (ioctl(fd, FE_GET_INFO  ,&luca) <0){
                
perror("GET_INFO: ");
                return -1;
    }

	printf("\nfreq min:%
d", luca.frequency_min);
	printf("\nfreq max:%d", luca.frequency_max);

	if 
(ioctl(fd, FE_READ_STATUS  ,&status) <0){
                perror
("FE_READ_STATUS: ");
                return -1;
    }

    // apro il demux


    printf("\nstato :%d", status);
    if((md = open(MD,O_RDWR|O_NONBLOCK)) < 0)
{
                perror("DEMUX DEVICE: ");
                return -1;
    }


    //setto il demux

    filtri.pid = 1296;
    filtri.input = 
DMX_IN_FRONTEND;
    filtri.output = DMX_OUT_TAP;
    filtri.pes_type = 
DMX_PES_OTHER;
    filtri.flags = DMX_IMMEDIATE_START;
    if (ioctl(md, 
DMX_SET_PES_FILTER, &filtri) < 0) {
            perror("DEMUX DEVICE: ");

            return -1;
    }

    //apro il dvr

    //if ((dvr = open(DVR, 
O_RDONLY|O_NONBLOCK)) < 0) {
      //      perror("DVR DEVICE : ");
//        
/    return -1;
  //  }

    if ((dvr_out = open
("/home/lucak904/Scrivania/Luca/prog_c/sat/prova_scar.txt", O_WRONLY)) < 0) {

            perror(" DVR FILE : ");
            return -1;
    }


    if((len 
= read(md,buf, BUFFY)) < 0){
        perror("non leggo");
    }
    else{

        write(dvr_out,buf,len);

    }

    chiudo_fd = close(fd);
    
chiudo_md = close(md);
    //chiudo_dvr = close(dvr);
}

It is just a test

every time i get Resource temporarily unavailable
For my understanding it means 
that nothing is readed from demux device, wath is wrong , the pid and frequency 
are ok the SNR is more than 70%

Thanks 

Luca

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
